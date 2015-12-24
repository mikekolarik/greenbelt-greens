var jqueryModule = angular.module('externalServices', []);

jqueryModule

    .factory('$', ['$window', function($window) {
        return $window.$;
    }])

    .factory('Dragdealer', ['$window', function($window) {
        return $window.Dragdealer;
    }]);
