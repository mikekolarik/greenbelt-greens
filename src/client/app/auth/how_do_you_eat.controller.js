(function () {
    'use strict';

    angular
        .module('app.auth')
        .controller('HowDoYouEatController', HowDoYouEatController);

    HowDoYouEatController.$inject = [
        '$state', 'logger', 'requestservice', '$stateParams',
        '$q', 'UserModel', '$timeout', '$rootScope', 'PreloaderModel', '$scope'
    ];
    /* @ngInject */
    function HowDoYouEatController($state, logger, requestservice, $stateParams, $q, UserModel, $timeout, $rootScope, PreloaderModel, $scope) {
        var vm = this;

        vm.menu = {
            goToSignUp: goToSignUp,
            goToNutritionGoals: goToNutritionGoals,
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

            if (vm.model.user.data.dietaryPreferences.length === 0) {
                getDietaryPreferences();
            } else {
                $timeout(function() {
                    $rootScope.$broadcast('show-mt-content');
                }, 100);
            }
        }

        function getDietaryPreferences() {
            return requestservice.run('getDietaryPreferences', {})
                .then(function (received) {
                console.log('getDietaryPreferences');
                console.log(received);
                if (received.data.success === 0) {
                    //logger.success('Dietary preferences successfully loaded');
                    parseDietaryPreferences(received);
                } else {
                    console.log(received.data.message);
                    //logger.error(received.data.message);
                }
                return received;
            });
        }

        function parseDietaryPreferences(received) {
            vm.model.user.data.dietaryPreferences = received.data.result;
            PreloaderModel.api.preloadImages(vm.model.user.data.dietaryPreferences, 'picture', function() {
                $scope.$apply();
                $timeout(function() {
                    $rootScope.$broadcast('show-mt-content');
                }, 100);
            });
        }

        function toggleSelection(item) {
            item.selected = !item.selected;
        }

        function goToSignUp() {
            $state.go('signup');
        }

        function goToNutritionGoals() {
            UserModel.data.dietaryPreferencesSelectedIds = [];
            vm.model.user.data.dietaryPreferences.forEach(function(preference) {
                if (preference.selected) {
                    UserModel.data.dietaryPreferencesSelectedIds.push(preference.id);
                }
            });
            if (UserModel.data.dietaryPreferencesSelectedIds.length === 0) {
                vm.model.user.data.dietaryPreferences.forEach(function(preference) {
                    if (preference.id === 1) {
                        preference.selected = true;
                        UserModel.data.dietaryPreferencesSelectedIds.push(preference.id);
                    }
                });
            }
            UserModel.api.saveToStorage();
            $state.go('nutrition_goals');
        }

    }
})();
