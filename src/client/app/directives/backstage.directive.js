(function () {
    'use strict';

    angular
        .module('app.core')
        .directive('mtBackstage', BackstageDirective);

    BackstageDirective.$inject = ['$timeout'];

    function BackstageDirective($timeout) {

        return {
            restrict: 'A',
            link: function($scope, elem, attrs) {
                elem.fadeIn();
                $scope.$on('show-mt-content', function() {
                    $timeout(function() {
                        window.scrollTo(0, 0);
                        elem.fadeOut();
                    });
                });
            }
        };
    }

})();
