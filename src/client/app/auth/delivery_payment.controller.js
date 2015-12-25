(function () {
    'use strict';

    angular
        .module('app.auth')
        .controller('DeliveryPaymentController', DeliveryPaymentController);

    DeliveryPaymentController.$inject = [
        '$state', 'logger', 'requestservice', '$stateParams',
        '$q', 'UserModel', '$timeout', '$rootScope', '$mdDialog', '$scope'
    ];
    /* @ngInject */
    function DeliveryPaymentController($state, logger, requestservice, $stateParams, $q, UserModel, $timeout, $rootScope, $mdDialog, $scope) {
        var vm = this;

        vm.menu = {
            signUp: signUp,
            goToAccountCreation: goToAccountCreation,
            popupTermsOfUse: popupTermsOfUse,
            checkReferralCode: checkReferralCode,
            clearRefCodeError: clearRefCodeError,
            clearStripeError: clearStripeError,
            signUpInProcess: false
        };

        vm.model = {
            infoBlocks: {},
            user: UserModel,
            deliveryDate: '',
            disableCode: false,
            stripeErrorMessage: '',
            stripeErrorCodes: {
                cvcErrors: ['invalid_cvc', 'incorrect_cvc'],
                expDateErrors: ['invalid_expiry_month', 'invalid_expiry_year']
            }
        };

        activate();

        function activate() {
            getDeliveryDate();
            UserModel.api.loadFromStorage();
            console.log('UserModel', UserModel);
            $timeout(function() {
                $rootScope.$broadcast('show-mt-content');
            }, 100);
        }

        function signUpUserCallback() {
            return requestservice.run('signUpUser',
                {
                    user: {
                        'ingredient_ids': UserModel.data.selectedIngredientsIds,
                        'first_name': UserModel.data.firstName,
                        'last_name': UserModel.data.lastName,
                        'zip_code': parseInt(UserModel.data.zipCode),
                        'email': UserModel.data.email,
                        'address1': UserModel.data.streetAddress,
                        'address2': UserModel.data.streetAddress2,
                        'meal_type_id': UserModel.data.selectedMealType ? UserModel.data.selectedMealType.id : null,

                        'weekend_delivery_range': UserModel.data.deliveryRangeWeekend,
                        'weekday_delivery_range': UserModel.data.deliveryRangeWeekday,

                        'delivery_instructions': UserModel.data.deliveryInstructions,
                        'phone': UserModel.data.phone,
                        'plan_id': UserModel.data.selectedPlan ? UserModel.data.selectedPlan.id : null,
                        'customer_id': 1,
                        'subscription_id': 1,
                        'facebook_id': UserModel.data.facebookId,
                        'password': UserModel.data.password,
                        'total_amount': Math.max(0, UserModel.data.selectedPlan.numberOfMeals *
                                        (UserModel.data.selectedPlan.price + UserModel.data.selectedPlan.delivery) -
                                        UserModel.data.discount),
                        'first_delivery_date': vm.model.deliveryDate,
                        'number_of_meals': UserModel.data.selectedPlan.numberOfMeals,

                        'card_name': UserModel.data.cardHolder,
                        'card_cvc': parseInt(UserModel.data.csv),
                        'card_number': parseInt(UserModel.data.cardNumber),
                        'card_exp_month': parseInt(UserModel.data.expiryDate[0] +
                            UserModel.data.expiryDate[1]),
                        'card_exp_year': parseInt(UserModel.data.expiryDate[3] +
                            UserModel.data.expiryDate[4] +
                            UserModel.data.expiryDate[5] +
                            UserModel.data.expiryDate[6]),
                        'referral_code': vm.model.user.data.referralCode
                    }
                })
                .then(function (received) {
                    if (received.data.success === 0) {
                        //logger.success('User successfully created');
                        UserModel.referralCode = received.data.result['referral_code'];
                        $state.go('thanks_page');
                    } else {
                        vm.menu.signUpInProcess = false;
                        //logger.error(received.data.message);
                        vm.model.stripeErrorMessage = JSON.parse(received.data.message).error.message;
                        var errorCode = JSON.parse(received.data.message).error.code;
                        if (vm.model.stripeErrorCodes.cvcErrors.indexOf(errorCode) > -1) {
                            $scope.cardInfo.csv.$setValidity('stripe_error', false);
                            $scope.cardInfo.csv.$setTouched();
                        } else {
                            if (vm.model.stripeErrorCodes.expDateErrors.indexOf(errorCode) > -1) {
                                $scope.cardInfo.expiryDate.$setValidity('stripe_error', false);
                                $scope.cardInfo.expiryDate.$setTouched();
                            } else {
                                $scope.cardInfo.cardNumber.$setValidity('stripe_error', false);
                                $scope.cardInfo.cardNumber.$setTouched();
                            }
                        }
                    }
                    return received;
                });
        }

        function fieldsValidations() {
            if ($scope.deliveryPayment.$valid && $scope.cardInfo.$valid) {
                return true;
            } else {
                angular.forEach($scope.deliveryPayment.$error, function(field) {
                    angular.forEach(field, function(errorField) {
                        errorField.$setTouched();
                    });
                });
                angular.forEach($scope.cardInfo.$error, function(field) {
                    angular.forEach(field, function(errorField) {
                        errorField.$setTouched();
                    });
                });
                return false;
            }
        }

        function checkReferralCode() {
            clearRefCodeError();
            requestservice.run('checkReferralCodeValidity', {
                'referral_code': vm.model.user.data.referralCode
            }).then(function (received) {
                if (received.data.success === 0) {
                    vm.model.user.data.discount = received.data.result.discount / 100;
                    vm.model.disableCode = true;
                } else {
                    $scope.referralCode.referralCode.$setValidity('code_error', false);
                    $scope.referralCode.referralCode.$setTouched();
                    //logger.error('Invalid referral code');
                }
            });
        }

        function clearRefCodeError() {
            $scope.referralCode.referralCode.$setValidity('code_error', true);
            $scope.referralCode.referralCode.$setValidity('code_did_not_checked', true);
        }

        function clearStripeError(param) {
            $scope.cardInfo[param].$setValidity('stripe_error', true);
        }

        function signUp() {
            vm.menu.signUpInProcess = true;
            if (fieldsValidations()) {
                UserModel.api.saveToStorage();
                if (!vm.model.user.data.referralCode || (vm.model.user.data.referralCode && vm.model.disableCode)) {
                    signUpUserCallback();
                } else {
                    $scope.referralCode.referralCode.$setValidity('code_did_not_checked', false);
                    $scope.referralCode.referralCode.$setTouched();
                    vm.menu.signUpInProcess = false;
                }
            } else {
                vm.menu.signUpInProcess = false;
            }
        }

        function goToAccountCreation() {
            UserModel.api.saveToStorage();
            $state.go('account_creation');
        }

        function getDeliveryDate() {
            return requestservice.run('getDeliveryDate', {})
                .then(function (received) {
                    if (received.data.success === 0) {
                        vm.model.deliveryDate = received.data.result['first_delivery_date'];
                    } else {
                        console.log(received.data.message);
                    }
                    return received;
                });

        }

        function popupTermsOfUse() {
            $mdDialog.show({
                controller: 'TermsOfUseController',
                controllerAs: 'vm',
                templateUrl: 'app/popover/terms_of_use.html',
                //parent: angular.element($document.body),
                clickOutsideToClose: true,
                scope: $rootScope.$new()
            });
        }
    }
})();
