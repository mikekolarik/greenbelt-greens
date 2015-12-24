(function () {
    'use strict';

    angular
        .module('app.core')

        .directive('owlCarousel', ['$', '$rootScope', '$timeout', function ($, $rootScope, $timeout) {
            return {
                nav:true,
                restrict: 'E',
                transclude: false,
                link: function (scope) {
                    scope.initCarousel = function (element) {
                        // provide any default options you want
                        var defaultOptions = {};
                        var customOptions = scope.$eval($(element).attr('data-options'));
                        // combine the two options objects
                        for (var key in customOptions) {
                            if (customOptions.hasOwnProperty(key)) {
                                defaultOptions[key] = customOptions[key];
                            }
                        }

                        element.on('changed.owl.carousel', function(event) {
                            var sync = $(element.attr('data-sync'));
                            if (event.namespace && event.property.name === 'position') {
                                var target = event.relatedTarget.relative(event.property.value, true);
                                sync.owlCarousel('to', target, 300, true);
                            }
                        });

                        // init carousel
                        $(element).owlCarousel(defaultOptions);
                        $timeout(function() {
                            console.log('carousel loaded');
                            $rootScope.$broadcast('owl-carousel-loaded', element.attr('id'));
                        }, 100);
                    };
                }
            };
        }])

        .directive('owlCarouselItem', ['$timeout', '$rootScope', function ($timeout, $rootScope) {
            return {
                restrict: 'A',
                transclude: false,
                link: function (scope, element) {
                    // wait for the last item in the ng-repeat then call init
                    if (scope.$last) {
                        $timeout(function() {
                            scope.initCarousel(element.parent());
                        }, 100);
                    }
                }
            };
        }]);

})();

