(function () {
    'use strict';

    angular
        .module('app.core')
        .directive('mtCompareTo', CompareToDirective);

    CompareToDirective.$inject = [];

    function CompareToDirective() {

        return {
            require: 'ngModel',
            scope: {
                otherModelValue: '=mtCompareTo'
            },
            link: function(scope, element, attributes, ngModel) {

                ngModel.$validators.mtCompareTo = function(modelValue) {
                    return modelValue === scope.otherModelValue;
                };

                scope.$watch('otherModelValue', function() {
                    ngModel.$validate();
                });
            }
        };
    }

})();
