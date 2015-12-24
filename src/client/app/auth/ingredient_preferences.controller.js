(function () {
    'use strict';

    angular
        .module('app.auth')
        .controller('IngredientPreferencesController', IngredientPreferencesController);

    IngredientPreferencesController.$inject = [
        '$state', 'logger', 'requestservice', '$stateParams',
        '$q', 'UserModel', '$scope', '$timeout', '$', '$rootScope'
    ];
    /* @ngInject */
    function IngredientPreferencesController($state, logger, requestservice, $stateParams, $q, UserModel, $scope, $timeout, $, $rootScope) {
        var vm = this;

        vm.menu = {
            goToNutritionGoals: goToNutritionGoals,
            goToExampleMeals: goToExampleMeals,
            clickTab: clickTab,
            countSelectedInCategory: countSelectedInCategory,
            toggleIngredientCategory: toggleIngredientCategory
        };

        vm.model = {
            user: UserModel,
            infoBlocks: {}
        };

        vm.view = {
            showExcluded: false
        };

        activate();

        function activate() {
            UserModel.api.loadFromStorage();

            if (vm.model.user.data.categoryGroups.length === 0) {
                getIngredients();
            } else {
                //parseCategoryGroups();
                $timeout(function() {
                    $rootScope.$broadcast('show-mt-content');
                }, 100);
            }

            //var container = angular.element(document.getElementById('container'));
            //var header = angular.element(document.getElementById('shrinkable-header'));
            //var height = header.outerHeight(true);
            //var scrollUp = false;
            //var lastY;
            //
            //$(container).bind('touchstart', function(e) {
            //    lastY = e.originalEvent.touches[0].clientY;
            //});
            //
            //$(container).bind('touchmove', function (e) {
            //    header = angular.element(document.getElementById('shrinkable-header'));
            //    if (header.is(':hidden')) { height = header.outerHeight(true); }
            //
            //    var currentY = e.originalEvent.touches[0].clientY;
            //    if (currentY > lastY && scrollUp) {
            //        console.log('up' + height);
            //        header.slideDown(200);
            //        container.animate({height: '-=' + height}, 200);
            //        e.preventDefault();
            //    }
            //    if (currentY < lastY && !scrollUp) {
            //        console.log('down' + height);
            //        container.animate({height: '+=' + height}, 200);
            //        header.slideUp(200);
            //        e.preventDefault();
            //    }
            //
            //    if (currentY > lastY) {
            //        scrollUp = false;
            //    } else if (currentY < lastY) {
            //        scrollUp = true;
            //    }
            //    lastY = currentY;
            //});
        }

        function getIngredients() {
            return requestservice.run('getIngredients', {})
                .then(function (received) {
                    console.log('getIngredients');
                    console.log(received);
                    if (received.data.success === 0) {
                        //logger.success('Dietary preferences successfully loaded');
                        vm.model.user.data.categoryGroups = received.data.result;
                        parseCategoryGroups();
                    } else {
                        console.log(received.data.message);
                        //logger.error(received.data.message);
                    }
                    return received;
                });
        }

        function parseCategoryGroups() {
            vm.model.user.data.categoryGroups.forEach(function(categoryGroup) {
                categoryGroup['ingredient_categories'].forEach(function(ingredientCategory) {
                    ingredientCategory.ingredients.forEach(function(ingredient) {
                        ingredient.selected = false;
                    });
                });
            });

            vm.model.user.data.categoryGroups.forEach(function(categoryGroup) {
                categoryGroup['ingredient_categories'].forEach(function(ingredientCategory) {
                    ingredientCategory.ingredients.forEach(function(ingredient) {
                        var ingredientGoals = [];
                        ingredient['dietary_goals'].forEach(function(dietaryGoal) {
                            ingredientGoals.push(dietaryGoal.id);
                        });

                        var ingredientPreferences = [];
                        ingredient['dietary_preferences'].forEach(function(dietaryPreference) {
                            ingredientPreferences.push(dietaryPreference.id);
                        });

                        var count = 0;
                        UserModel.data.dietaryGoalsSelectedIds.forEach(function(oneSelectedGoalId) {
                            if (ingredientGoals.indexOf(oneSelectedGoalId) !== -1) {
                                count++;
                            }
                            if (count === UserModel.data.dietaryGoalsSelectedIds.length) {
                                ingredient.selectedByGoal = true;
                            }
                        });

                        count = 0;
                        UserModel.data.dietaryPreferencesSelectedIds.forEach(function(oneSelectedPreferenceId) {
                            if (ingredientPreferences.indexOf(oneSelectedPreferenceId) !== -1) {
                                count++;
                            }
                            if (count === UserModel.data.dietaryPreferencesSelectedIds.length) {
                                ingredient.selectedByPreference = true;
                            }
                        });

                        if (ingredient.selectedByGoal && ingredient.selectedByPreference) {
                            ingredient.selected = true;
                        }
                    });
                });
            });

            $timeout(function() {
                $rootScope.$broadcast('show-mt-content');
            }, 100);
        }

        function collectSelectedIngredientIds() {
            UserModel.data.selectedIngredientsIds = [];
            vm.model.user.data.categoryGroups.forEach(function(categoryGroup) {
                categoryGroup['ingredient_categories'].forEach(function(ingredientCategory) {
                    ingredientCategory.ingredients.forEach(function(ingredient) {
                        if (ingredient.selected) {
                            UserModel.data.selectedIngredientsIds.push(ingredient.id);
                        }
                    });
                });
            });
        }

        function toggleIngredientCategory(id) {
            console.log('#ingredient-category-' + id);
            $('#ingredient-category-' + id).slideToggle();
        }

        function countSelectedInCategory(ingredientCategory) {
            var selected = 0;
            ingredientCategory.ingredients.forEach(function(ingredient) {
                if (ingredient.selected) {
                    selected++;
                }
            });
            return selected;
        }

        function goToNutritionGoals() {
            UserModel.api.saveToStorage();
            $state.go('nutrition_goals');
        }

        function goToExampleMeals() {
            collectSelectedIngredientIds();
            UserModel.api.saveToStorage();
            $state.go('example_meals');
        }

        function clickTab(param) {
            vm.view.showExcluded = param;
        }
    }
})();
