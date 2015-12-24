(function () {
    'use strict';

    angular
        .module('app.auth')
        .controller('TweakYourPlanController', TweakYourPlanController);

    TweakYourPlanController.$inject = [
        '$state', 'logger', 'requestservice', '$stateParams',
        '$q', 'UserModel', 'PreloaderModel', '$rootScope', '$timeout'
    ];
    /* @ngInject */
    function TweakYourPlanController($state, logger, requestservice, $stateParams, $q, UserModel, PreloaderModel, $rootScope, $timeout) {
        var vm = this;

        vm.menu = {
            selectDeliveryRangeWeekend: selectDeliveryRangeWeekend,
            selectDeliveryRangeWeekday: selectDeliveryRangeWeekday,
            selectMealPlan: selectMealPlan,
            selectMealType: selectMealType,

            goToExampleMeals: goToExampleMeals,
            goToAccountCreation: goToAccountCreation

        };

        vm.model = {
            user: UserModel,
            mealPlans: [
                {
                    id: 10027,
                    title: '4 Meals / Week plan',
                    numberOfMeals: 4,
                    price: 9.99,
                    picture: '../images/one_persone.svg',
                    delivery: 2
                },
                {
                    id: 10028,
                    title: '8 Meals / Week plan',
                    numberOfMeals: 8,
                    price: 9.99,
                    picture: '../images/two_persone.svg',
                    delivery: 1
                }
            ],
            deliveryRangesWeekend: [
                {id: 0, start: '5', end: '6 pm'},
                {id: 1, start: '6', end: '7 pm'},
                {id: 2, start: '7', end: '8 pm'},
                {id: 3, start: '8', end: '9 pm'}
            ],
            deliveryRangesWeekday: [
                {id: 0, start: '5', end: '6 am'},
                {id: 1, start: '6', end: '7 am'},
                {id: 2, start: '7', end: '8 am'},
                {id: 3, start: '8', end: '9 am'}
            ],
            mealTypes: []
        };

        activate();

        function activate() {
            UserModel.api.loadFromStorage();

            selectDeliveryRangeWeekday(UserModel.data.deliveryRangeWeekdaySelected);
            selectDeliveryRangeWeekend(UserModel.data.deliveryRangeWeekendSelected);
            selectMealPlan(UserModel.data.selectedPlan);

            getMealTypes();
        }

        function getMealTypes() {
            return requestservice.run('getMealTypes', {})
                .then(function (received) {
                    console.log(received);
                    if (received.data.success === 0) {
                        vm.model.mealTypes = received.data.result;
                        selectMealType(UserModel.data.selectedMealType);
                        PreloaderModel.api.preloadImages(vm.model.mealPlans, 'picture', function() {
                            $timeout(function() {
                                $rootScope.$broadcast('show-mt-content');
                            }, 100);
                        });
                    } else {
                        console.log(received.data.message);
                        //logger.error(received.data.message);
                    }
                    return received;
                });
        }

        function selectMealType(mealType) {
            if (mealType) {
                vm.model.mealTypes.forEach(function(item) {
                    if (item.id === mealType.id) {
                        item.selected = true;
                        UserModel.data.selectedMealType = item;
                    } else {
                        item.selected = false;
                    }
                });
            } else {
                var item = vm.model.mealTypes[2];
                item.selected = true;
                UserModel.data.selectedMealType = item;
            }
        }

        function selectDeliveryRangeWeekend(deliveryRangeWeekend) {
            if (deliveryRangeWeekend) {
                vm.model.deliveryRangesWeekend.forEach(function(item) {
                    if (item.id === deliveryRangeWeekend.id) {
                        item.selected = true;
                        UserModel.data.deliveryRangeWeekend = item.start + ' - ' + item.end;
                        UserModel.data.deliveryRangeWeekendSelected = item;
                    } else {
                        item.selected = false;
                    }
                });
            } else {
                var item = vm.model.deliveryRangesWeekend[3];
                item.selected = true;
                UserModel.data.deliveryRangeWeekend = item.start + ' - ' + item.end;
                UserModel.data.deliveryRangeWeekendSelected = item;
            }
        }

        function selectDeliveryRangeWeekday(deliveryRangeWeekday) {
            if (deliveryRangeWeekday) {
                vm.model.deliveryRangesWeekday.forEach(function(item) {
                    if (item.id === deliveryRangeWeekday.id) {
                        item.selected = true;
                        UserModel.data.deliveryRangeWeekday = item.start + ' - ' + item.end;
                        UserModel.data.deliveryRangeWeekdaySelected = item;
                    } else {
                        item.selected = false;
                    }
                });
            } else {
                var item = vm.model.deliveryRangesWeekday[3];
                item.selected = true;
                UserModel.data.deliveryRangeWeekday = item.start + ' - ' + item.end;
                UserModel.data.deliveryRangeWeekdaySelected = item;
            }
        }

        function selectMealPlan(mealPlan) {
            console.log('selectMealPlan', mealPlan);
            if (mealPlan) {
                vm.model.mealPlans.forEach(function(item) {
                    if (item.id === mealPlan.id) {
                        item.selected = true;
                        UserModel.data.selectedPlan = item;
                    } else {
                        item.selected = false;
                    }
                });
            } else {
                var item = vm.model.mealPlans[0];
                item.selected = true;
                UserModel.data.selectedPlan = item;
            }
        }

        function goToExampleMeals() {
            UserModel.api.saveToStorage();
            $state.go('example_meals');
        }

        function goToAccountCreation() {
            UserModel.api.saveToStorage();
            $state.go('account_creation');
        }
    }
})();
