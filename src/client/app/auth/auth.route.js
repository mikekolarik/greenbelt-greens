(function() {
    'use strict';

    angular
        .module('app.auth')
        .run(appRun);

    appRun.$inject = ['routerHelper', '$rootScope'];
    /* @ngInject */
    function appRun(routerHelper, $rootScope) {
        routerHelper.configureStates(getStates($rootScope));
    }

    function getStates($rootScope) {
        var isMobile = $rootScope.willGoMobile();
        return [
            {
                state: 'signin',
                config: {
                    url: '/signin',
                    templateUrl: 'app/auth/signin.html',
                    controller: 'SignInController',
                    controllerAs: 'vm',
                    title: 'Sign In',
                    settings: {}
                }
            },
            {
                state: 'signup',
                config: {
                    url: '/signup',
                    templateUrl: isMobile ? 'app/auth/signup.html' : 'app/auth/signup_desktop.html',
                    controller: 'SignUpController',
                    controllerAs: 'vm',
                    title: 'Zip code',
                    settings: {}
                }
            },
            {
                state: 'how_do_you_eat',
                config: {
                    //url: '/how_do_you_eat',
                    url: '/dietary_preferences',
                    templateUrl: isMobile ? 'app/auth/how_do_you_eat.html' : 'app/auth/how_do_you_eat_desktop.html',
                    controller: 'HowDoYouEatController',
                    controllerAs: 'vm',
                    //title: 'How do you eat',
                    title: 'Dietary Preferences',
                    settings: {}
                }
            },
            {
                state: 'nutrition_goals',
                config: {
                    url: '/nutrition_goals',
                    templateUrl: isMobile ? 'app/auth/nutrition_goals.html' : 'app/auth/nutrition_goals_desktop.html',
                    controller: 'NutritionGoalsController',
                    controllerAs: 'vm',
                    title: 'Nutritional Goals',
                    settings: {}
                }
            },
            {
                state: 'example_meals',
                config: {
                    url: '/example_meals',
                    templateUrl: isMobile ? 'app/auth/example_meals.html' : 'app/auth/example_meals_desktop.html',
                    controller: 'ExampleMealsController',
                    controllerAs: 'vm',
                    title: 'Example meals',
                    settings: {}
                }
            },
            {
                state: 'account_creation',
                config: {
                    url: '/account_creation',
                    templateUrl:  isMobile ? 'app/auth/account_creation.html' : 'app/auth/account_creation_desktop.html',
                    controller: 'AccountCreationController',
                    controllerAs: 'vm',
                    title: 'Account creation',
                    settings: {}
                }
            },
            {
                state: 'delivery_payment',
                config: {
                    url: '/delivery_payment',
                    templateUrl: isMobile ? 'app/auth/delivery_payment.html' : 'app/auth/delivery_payment_desktop.html',
                    controller: 'DeliveryPaymentController',
                    controllerAs: 'vm',
                    title: 'Delivery and payment',
                    settings: {}
                }
            },
            {
                state: 'ingredient_preferences',
                config: {
                    url: '/ingredient_preferences',
                    templateUrl: isMobile ? 'app/auth/ingredient_preferences.html' : 'app/auth/ingredient_preferences_desktop.html',
                    controller: 'IngredientPreferencesController',
                    controllerAs: 'vm',
                    title: 'Ingredient Preferences',
                    settings: {}
                }
            },
            {
                state: 'tweak_your_plan',
                config: {
                    //url: '/tweak_your_plan',
                    url: '/pick_your_plan',
                    templateUrl: isMobile ? 'app/auth/tweak_your_plan.html' : 'app/auth/tweak_your_plan_desktop.html',
                    controller: 'TweakYourPlanController',
                    controllerAs: 'vm',
                    //title: 'Tweak your plan',
                    title: 'Pick Your Plan',
                    settings: {}
                }
            },
            {
                state: 'thanks_page',
                config: {
                    controller: 'ThanksController',
                    controllerAs: 'vm',
                    url: '/thanks',
                    templateUrl: isMobile ? 'app/auth/thanks.html' : 'app/auth/thanks_desktop.html',
                    title: 'Thanks page'
                }
            },
            {
                state: 'thanks_subscribing',
                config: {
                    controller: 'ThanksController',
                    controllerAs: 'vm',
                    url: '/thanks_subscribing',
                    templateUrl:  isMobile ? 'app/auth/thanks_subscribing.html' : 'app/auth/thanks_subscribing_desktop.html',
                    title: 'Thanks page'
                }
            }
        ];
    }
})();
