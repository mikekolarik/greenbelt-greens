(function () {
    'use strict';

    angular
        .module('app.core')
        .directive('setClassWhenAtTop', StickyHeaderDirective);

    StickyHeaderDirective.$inject = [];

    function StickyHeaderDirective() {

        return {
            restrict: 'A',
            scope: {
                container: '=',
                //spacer: '=',
                offset: '='
            },
            link: function (scope, element, attrs) {
                var cont = angular.element(scope.container); // wrap window object as jQuery object
                //var spacer = angular.element(scope.spacer);

                var topClass = attrs.setClassWhenAtTop, // get CSS class from directive's attribute value
                    offsetTop = element.offset().top; // get element's top relative to the document

                cont.on('scroll', function (e) {
                    if (cont.scrollTop() + scope.offset >= offsetTop) {
                        element.addClass(topClass);
                        //spacer.height(element.height());
                    } else {
                        element.removeClass(topClass);
                        //spacer.height(0);
                    }
                });
            }
        };
    }

})();

