(function() {
    'use strict';

    angular.module('app.popover', [
        'app.core',
        'app.widgets'
    ])

        .run(loadPopoverContents);

    loadPopoverContents.$inject = ['$rootScope', 'PopoverContent'];

    function loadPopoverContents($rootScope, PopoverContent) {
        PopoverContent.api.loadPopoverContents();
    }
})();
