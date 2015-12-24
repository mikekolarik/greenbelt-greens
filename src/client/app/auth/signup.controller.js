(function () {
    'use strict';

    angular
        .module('app.auth')
        .controller('SignUpController', SignUpController);

    SignUpController.$inject = [
        '$state', 'logger', 'requestservice', '$stateParams',
        '$q', '$scope', 'UserModel', 'PreloaderModel', '$rootScope', '$timeout', '$window'
    ];
    /* @ngInject */
    function SignUpController(
        $state, logger, requestservice, $stateParams,
        $q, $scope, UserModel, PreloaderModel, $rootScope, $timeout, $window
    ) {
        var vm = this;

        vm.menu = {
            backToEnterZipCode: backToEnterZipCode,
            submit: submit,
            subscribeByEmail: subscribeByEmail
        };

        vm.model = {
            zipCode: '',
            userEmail: '',
            checkZipCodeFormat: checkZipCodeFormat,
            zipCodeIsValid: true,
            user: UserModel,
            infoBlock: {},
            images: [
                {picture: $rootScope.willGoMobile() ? '../images/site/mobile_zip_img.jpg' : '../images/site/zip_img.jpg'},
                {picture: $rootScope.willGoMobile() ? '../images/site/mobile_bad_zip.jpg' : '../images/site/bad_zip.jpg'}
            ]
        };

        $scope.map = {
            center: {
                latitude: 40.748817,
                longitude: -73.985428
            },
            zoom: 14,
            marker: {
                latitude: 40.748817,
                longitude: -73.985428,
                options: {
                    disableDefaultUI: false
                }
            }
        };

        activate();

        function activate() {
            UserModel.api.clear();
            PreloaderModel.api.preloadImages(vm.model.images, 'picture', function() {
                $timeout(function() {
                    $rootScope.$broadcast('show-mt-content');
                }, 100);
            });
        }

        function submit() {
            $state.go('intro');
        }

        function subscribeByEmail() {
            if ($scope.enteremail.$valid) {
                return requestservice.run('subscribeNewUser', {
                    'subscription': {
                        'user_email': vm.model.userEmail,
                        'user_zip_code': vm.model.zipCode
                    }
                }).then(function (received) {
                    console.log('subscribeNewUser');
                    console.log(received);
                    if (received.data.success === 0) {
                        UserModel.referralCode = received.data.result['referral_code'];
                        $state.go('thanks_subscribing');
                    } else {
                        console.log(received.data.message);
                        //logger.error(received.data.message);
                    }
                    return received;
                });
            } else {
                $scope.enteremail.emailzip.$setTouched();
            }
        }

        //function zipCodeWasChanged() {
        //    vm.menu.zipCodeWasChecked = false;
        //}

        function backToEnterZipCode() {
            vm.model.userEmail = '';
            vm.model.zipCode = '';
            vm.model.zipCodeIsValid = true;
            //vm.menu.zipCodeWasChecked = false;
        }

        function checkZipCodeFormat() {
            console.log($scope.zipCodeForm);
            if ($scope.zipCodeForm.$valid) {
                return requestservice.run('checkZipCode', {
                    'validation': {
                        'zip_code': vm.model.zipCode
                    }
                }).then(function (received) {
                    console.log('checkZipCode');
                    console.log(received);
                    if (received.data.success === 0) {
                        //logger.success('Zip code is valid');
                        vm.model.user.data.zipCode = vm.model.zipCode;
                        $state.go('how_do_you_eat');
                    } else {
                        vm.model.zipCodeIsValid = false;
                        $window.ga('send', 'event', 'page', 'wrong_zip_code_page');
                    }
                    return received;
                });
            } else {
                $scope.zipCodeForm.zipCode.$setTouched();
            }
        }

    }
})();
