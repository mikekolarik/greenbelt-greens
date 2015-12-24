(function () {
    'use strict';

    angular
        .module('app.core')
        .factory('UserModel', UserModel);

    UserModel.$inject = ['logger', '$localStorage', '$base64'];
    /* @ngInject */
    function UserModel(logger, $localStorage, $base64) {
        var userModel;

        var clearData = {
            dietaryPreferences: [],
            dietaryPreferencesSelectedIds: [],

            dietaryGoals: [],
            dietaryGoalsSelectedIds: [],

            categoryGroups: [],
            selectedIngredientsIds: [],

            discount: 0,

            zipCode: null,
            email: null,
            firstName: null,
            lastName: null,
            password: null,
            passwordConfirm: null,
            streetAddress: null,
            streetAddress2: null,
            phone: '',
            deliveryInstructions: null,
            deliveryRangeWeekend: null,
            deliveryRangeWeekendSelected: null,
            deliveryRangeWeekday: null,
            deliveryRangeWeekdaySelected: null,
            selectedMealType: null,
            selectedPlan: null,
            facebookId: null,

            cardHolder: null,
            cardNumber: null,
            expiryDate: null,
            csv: null,

            referralCode: null
        };

        userModel = {
            isAuthChecked: false,
            isSignedIn: false,
            api: {
                saveToStorage: saveToStorage,
                loadFromStorage: loadFromStorage,
                clear: clear
            },
            data: JSON.parse(JSON.stringify(clearData)),
            referralCode: ''
        };

        return userModel;

        function saveToStorage() {
            $localStorage.mealTicketData = $base64.encode(JSON.stringify(userModel.data));
        }

        function loadFromStorage() {
            if (typeof $localStorage.mealTicketData !== 'undefined' &&
                $localStorage.mealTicketData !== null)
            {
                try {
                    userModel.data = JSON.parse($base64.decode($localStorage.mealTicketData));
                } catch (err) {
                    console.log('User data is broken. It will be reset.');
                    saveToStorage();
                }
            }
        }

        function clear() {
            delete $localStorage.mealTicketData;
            userModel.data = JSON.parse(JSON.stringify(clearData));
        }
    }
})();
