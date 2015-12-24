(function () {
    'use strict';

    angular
        .module('app.auth')
        .controller('ExampleMealsController', ExampleMealsController);

    ExampleMealsController.$inject = [
        '$state', 'logger', 'requestservice', '$stateParams',
        '$q', 'UserModel', '$', '$timeout', '$rootScope', '$scope', 'PreloaderModel', '$window'
    ];
    /* @ngInject */
    function ExampleMealsController($state, logger, requestservice, $stateParams, $q, UserModel, $, $timeout,
                                    $rootScope, $scope, PreloaderModel, $window) {
        var vm = this;

        vm.menu = {
            goToIngredients: goToIngredients,
            goToTweakYourPlan: goToTweakYourPlan,

            carouselNext: carouselNext,
            carouselPrev: carouselPrev
        };

        vm.model = {
            infoBlocks: {},
            exampleMeals: [],
            imagesLoaded: false
        };

        activate();

        function activate() {
            UserModel.api.loadFromStorage();

            getExampleMeals();
        }

        function getExampleMeals() {
            return requestservice.run('getExampleMeals', {})
                .then(function (received) {
                    console.log('getExampleMeals');
                    console.log(received);
                    if (received.data.success === 0) {
                        //logger.success('Dietary goals successfully loaded');
                        parseExampleMeals(received);
                    } else {
                        console.log(received.data.message);
                        //logger.error(received.data.message);
                    }
                    return received;
                });
        }

        function parseExampleMeals(received) {
            console.log('parsing');
            vm.model.exampleMeals = received.data.result;
            PreloaderModel.api.preloadImages(vm.model.exampleMeals, 'meal_photo', function() {
                vm.model.imagesLoaded = true;
                $scope.$apply();
                console.log('all loaded');
                $rootScope.$on('owl-carousel-loaded', function(event, id) {
                    if (id === 'ex-meal-carousel') {
                        $timeout(function() {
                            $rootScope.$broadcast('show-mt-content');
                        }, 100);
                    }
                });
            });
        }

        function goToIngredients() {
            UserModel.api.saveToStorage();
            $state.go('ingredient_preferences');
        }

        function goToTweakYourPlan() {
            UserModel.api.saveToStorage();
            $state.go('tweak_your_plan');
        }

        function carouselNext() {
            $window.ga('send', 'event', 'button', 'next_testimonial_button');
            var owl = $('#ex-meal-carousel-main');
            if (!owl.length) {
                owl = $('#ex-meal-carousel');
            }
            owl.trigger('next.owl.carousel');
        }

        function carouselPrev() {
            $window.ga('send', 'event', 'button', 'next_testimonial_button');
            var owl = $('#ex-meal-carousel-main');
            if (!owl.length) {
                owl = $('#ex-meal-carousel');
            }
            owl.trigger('prev.owl.carousel');
        }
    }
})();
