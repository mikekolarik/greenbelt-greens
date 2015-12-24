(function () {
    'use strict';

    angular
        .module('app.core')
        .directive('pageDesktopHeader', pageDesktopHeader);

    pageDesktopHeader.$inject = [];

    function pageDesktopHeader () {
        return {
            restrict: 'E',
            replace: true,
            templateUrl: 'app/directives/header.html'
        };
    }
})();
