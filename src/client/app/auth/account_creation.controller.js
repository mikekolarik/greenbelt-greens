(function () {
    'use strict';

    angular
        .module('app.auth')
        .controller('AccountCreationController', AccountCreationController);

    AccountCreationController.$inject = [
        '$state', 'logger', 'requestservice', '$stateParams',
        '$q', 'UserModel', '$facebook', '$timeout', '$rootScope', '$scope'
    ];
    /* @ngInject */
    function AccountCreationController($state, logger, requestservice, $stateParams, $q, UserModel, $facebook, $timeout, $rootScope, $scope) {
        var vm = this;

        vm.menu = {
            goToTweakYourPlan: goToTweakYourPlan,
            goDeliveryPayment: goDeliveryPayment,
            connectWithFacebook: connectWithFacebook,
            clearEmailError: clearEmailError
        };

        vm.model = {
            infoBlocks: {},
            user: UserModel
        };

        activate();

        function activate() {
            UserModel.api.loadFromStorage();
            $timeout(function() {
                $rootScope.$broadcast('show-mt-content');
            }, 100);
        }

        function connectWithFacebook() {
            $facebook.login().then(function() {
                $facebook.api('/me',
                    {
                        fields: 'id, email, first_name, last_name'
                    }
                ).then(
                    function(response) {
                        console.log('Facebook responce');
                        console.log(response);
                        vm.model.user.data.firstName = response['first_name'];
                        vm.model.user.data.lastName = response['last_name'];
                        vm.model.user.data.email = response['email'];
                        vm.model.user.data.facebookId = response['id'];
                    });
            });
        }

        function goToTweakYourPlan() {
            UserModel.api.saveToStorage();
            $state.go('tweak_your_plan');
        }

        function goDeliveryPayment() {
            clearEmailError();
            if (fieldsValidations()) {
                checkIfUserExists(function() {
                    UserModel.api.saveToStorage();
                    $state.go('delivery_payment');
                });
            }
        }

        function clearEmailError() {
            $scope.userAccount.email.$setValidity('emailExists', true);
        }

        function checkIfUserExists(callback) {
            requestservice.run('checkIfUserExists', {
                'email': vm.model.user.data.email.toLowerCase()
            }).then(function (received) {
                if (received.data.success === 0) {
                    callback();
                } else {
                    $scope.userAccount.email.$setValidity('emailExists', false);
                    $scope.userAccount.email.$setTouched();
                }
            });
        }

        function fieldsValidations() {
            if ($scope.userAccount.$valid) {
                return true;
            } else {
                angular.forEach($scope.userAccount.$error, function(field) {
                    angular.forEach(field, function(errorField) {
                        errorField.$setTouched();
                    });
                });
                return false;
            }
        }
    }
})();
