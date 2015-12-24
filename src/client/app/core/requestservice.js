(function () {
    'use strict';

    angular
        .module('app.core')
        .factory('requestservice', requestservice);

    requestservice.$inject = [
        '$http', '$q', 'logger',
        'UserModel', '$state', 'config', '$', '$mdDialog', '$document', '$window', '$rootScope'
    ];
    /* @ngInject */
    function requestservice(
        $http, $q, logger,
        UserModel, $state, config, $, $mdDialog, $document, $window, $rootScope
    ) {
        var baseDomain = 'http://' + config.domainEndpoint + config.portEndpoint;
        var endpoints = {
            getIntros: {url: '/api/intro', method: 'GET'},
            checkZipCode: {url: '/api/check_for_valid.json', method: 'POST'},
            getDietaryPreferences: {url: '/api/dietary_preferences', method: 'GET'},
            getDietaryGoals: {url: '/api/dietary_goals', method: 'GET'},
            getInfoBlocks: {url: '/api/help_blocks', method: 'GET'},
            getExampleMeals: {url: '/api/meal_examples', method: 'GET'},
            getIngredients: {url: '/api/categories_groups/full_data', method: 'GET'},
            subscribeNewUser: {url: '/api/subscribe_new_user.json', method: 'POST'},
            signUpUser: {url: '/api/sign_up.json', method: 'POST'},
            getMealTypes: {url: '/api/meal_types', method: 'GET'},
            getDeliveryDate: {url: '/api/get_first_delivery_date.json', method: 'GET'},
            getPopoverContents: {url: '/api/popover_contents', method: 'GET'},
            checkReferralCodeValidity: {url: '/api/check_code_validity.json', method: 'POST'},
            checkIfUserExists: {url: '/api/check_if_user_exists.json', method: 'POST'}
        };

        var service = {
            run: makeRequest,
            modalWindowIsOpened: false
        };

        return service;

        function makeRequest(endpoint, data, inputHeaders) {
            var url = endpoints[endpoint].url;
            var fd = new FormData();
            var headers = inputHeaders || {};
            headers['Content-Type'] = 'application/json';

            if (typeof UserModel.data['auth_token'] !== 'undefined' &&
                UserModel.data['auth_token'] !== null)
            {
                headers['auth_token'] = UserModel.data['auth_token'];
            }

            data['mobile'] = $rootScope.willGoMobile();

            if (data['url_params'])
            {
                var keysArr = Object.keys(data['url_params']);
                keysArr.forEach(function(oneKey) {
                    url = url.replace(oneKey, data['url_params'][oneKey]);
                });

                delete data['url_params'];
            }

            var sendData = {
                method: endpoints[endpoint].method,
                url: baseDomain + url + '?' + $.now(),
                headers: headers
            };

            if (endpoints[endpoint].method === 'GET') {
                data['t'] = new Date().getTime();
                sendData['params'] = data;
            } else {
                sendData['data'] = data;
            }

            if (data['multipart']) {
                angular.forEach(data, function(value, key) {
                    fd.append(key, value);
                });

                sendData.transformRequest = angular.identity;
                sendData.data = fd;
                headers['Content-Type'] = undefined;
            }

            return $http(sendData)
            .then(success)
            .catch(error);

            function success(response) {
                console.log('responce');
                console.log(response);
                if (response.data.success.toString() === '401') {
                    UserModel.isSignedIn = false;
                    $state.go('signin');
                }
                return response;
            }

            function error(xhr, ajaxOptions, thrownError) {
                if (xhr.status === 0) {
                    noInternetConnectionDialog();
                    return {data: {success: -1, message: 'No internet connection'}};
                } else {
                    console.log('Error caused with error status ' + xhr.status);
                }
            }

            function noInternetConnectionDialog(ev) {
                if (!service.modalWindowIsOpened) {
                    service.modalWindowIsOpened = true;
                    var confirm = $mdDialog.confirm()
                        .title('No Internet Connection')
                        .content('It seems that internet connection was lost. Would you like to retry?')
                        .targetEvent(ev)
                        .ok('Yes')
                        .cancel('No');

                    $mdDialog.show(confirm).then(function() {
                        if ($state.current.name === 'signin' || $state.current.name === 'signup') {
                            $window.location.reload();
                        } else {
                            $state.go($state.$current, null, {reload: true});
                        }
                        console.log('reload');
                        service.modalWindowIsOpened = false;
                    }, function() {
                        $mdDialog.hide();
                        service.modalWindowIsOpened = false;
                    });
                }
            }
        }
    }
})();
