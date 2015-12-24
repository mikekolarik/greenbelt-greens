(function () {
    'use strict';

    angular
        .module('app.auth')
        .controller('NutritionGoalsController', NutritionGoalsController);

    NutritionGoalsController.$inject = [
        '$state', 'logger', 'requestservice', '$stateParams',
        '$q', 'UserModel', '$timeout', '$rootScope', 'PreloaderModel'
    ];
    /* @ngInject */
    function NutritionGoalsController($state, logger, requestservice, $stateParams, $q, UserModel, $timeout, $rootScope, PreloaderModel) {
        var vm = this;

        vm.menu = {
            goToDietaryPreferences: goToDietaryPreferences,
            goToIngredientPreferences: goToIngredientPreferences,
            select: toggleSelection
        };

        vm.model = {
            user: UserModel,
            infoBlocks: {}
        };

        activate();

        function activate() {
            UserModel.api.loadFromStorage();
            vm.model.user.data.categoryGroups = [];

            if (vm.model.user.data.dietaryGoals.length === 0) {
                getNutritionGoals();
            } else {
                $timeout(function() {
                    $rootScope.$broadcast('show-mt-content');
                }, 100);
            }
        }

        function getNutritionGoals() {
            return requestservice.run('getDietaryGoals', {})
                .then(function (received) {
                    console.log('getDietaryGoals');
                    console.log(received);
                    if (received.data.success === 0) {
                        //logger.success('Dietary goals successfully loaded');
                        parseDietaryGoals(received);
                    } else {
                        console.log(received.data.message);
                        //logger.error(received.data.message);
                    }
                    return received;
                });
        }

        function parseDietaryGoals(received) {
            vm.model.user.data.dietaryGoals = received.data.result;
            PreloaderModel.api.preloadImages(vm.model.user.data.dietaryGoals, 'picture', function() {
                $timeout(function() {
                    $rootScope.$broadcast('show-mt-content');
                }, 100);
            });
        }

        function goToDietaryPreferences() {
            UserModel.api.saveToStorage();
            $state.go('how_do_you_eat');
        }

        function toggleSelection(item) {
            item.selected = !item.selected;
        }

        function goToIngredientPreferences() {
            UserModel.data.dietaryGoalsSelectedIds = [];
            vm.model.user.data.dietaryGoals.forEach(function(goal) {
                if (goal.selected) {
                    UserModel.data.dietaryGoalsSelectedIds.push(goal.id);
                }
            });

            if (UserModel.data.dietaryGoalsSelectedIds.length === 0) {
                vm.model.user.data.dietaryGoals.forEach(function(goal) {
                    if (goal.id === 10) {
                        goal.selected = true;
                        UserModel.data.dietaryGoalsSelectedIds.push(goal.id);
                    }
                });
            }
            //if (UserModel.data.dietaryGoalsSelectedIds.length > 0) {
            UserModel.api.saveToStorage();
            $state.go('ingredient_preferences');
            //} else {
            //    logger.error('Please, select at least one dietary goal');
            //}
        }
    }
})();
