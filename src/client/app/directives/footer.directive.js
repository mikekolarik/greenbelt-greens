(function () {
    'use strict';

    angular
        .module('app.core')
        .directive('pageDesktopFooter', pageDesktopFooter);

    pageDesktopFooter.$inject = ['$mdDialog', '$rootScope'];

    function pageDesktopFooter ($mdDialog, $rootScope) {
        return {
            restrict: 'E',
            replace: true,
            templateUrl: 'app/directives/footer.html',
            link: link
        };

        function link(scope) {
            scope.menu = {
                popupTermsOfUse: popupTermsOfUse
            };

            function popupTermsOfUse() {
                $mdDialog.show({
                    controller: 'TermsOfUseController',
                    controllerAs: 'vm',
                    templateUrl: 'app/popover/terms_of_use.html',
                    //parent: angular.element($document.body),
                    clickOutsideToClose: true,
                    scope: $rootScope.$new()
                });
            }
        }
    }
})();
