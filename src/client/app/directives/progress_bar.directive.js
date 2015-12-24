(function () {
    'use strict';

    angular
        .module('app.core')
        .controller('ProgressBarController', ProgressBarController)
        .directive('mtProgressBar', ProgressBarDirective);

    //    Usage
    //    <mt-progress-bar number-of-dots="3" selected-index="0"></mt-progress-bar>
    //

    ProgressBarController.$inject = ['$scope'];
    /* @ngInject */
    function ProgressBarController($scope) {
        $scope.toArray = function(number) {
            return new Array(number);
        };
    }

    ProgressBarDirective.$inject = [];
    function ProgressBarDirective() {
        return {
            restrict: 'E',
            controller: 'ProgressBarController',
            scope: {
                numberOfDots: '=',
                selectedIndex: '='
            },
            template:
            '<div class="mt-progress-bar">' +
            '<span ng-repeat="dot in toArray(numberOfDots) track by $index" ' +
            '      class="mt-progress-bar-dot {{$index <= selectedIndex ? \'active\' : \'\'}}">' +
            '      </span>' +
            '</div>',
            link: function(scope, element, attribute) {
            }
        };
    }

})();

