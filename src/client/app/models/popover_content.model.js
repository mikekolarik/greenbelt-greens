(function () {
    'use strict';

    angular
        .module('app.core')
        .factory('PopoverContent', PopoverContent);

    PopoverContent.$inject = ['requestservice', '$mdDialog', '$document', '$rootScope', 'PreloaderModel'];
    /* @ngInject */
    function PopoverContent(requestservice, $mdDialog, $document, $rootScope, PreloaderModel) {
        var content;

        content = {
            popoverContents: [],
            api: {
                loadPopoverContents: loadPopoverContents
            }
        };

        $rootScope.showPopoverContent = showPopoverContent;

        return content;

        function loadPopoverContents() {
            return requestservice.run('getPopoverContents', {})
                .then(function (received) {
                    console.log('getPopoverContents');
                    console.log(received);
                    if (received.data.success === 0) {
                        content.popoverContents = received.data.result;
                        PreloaderModel.api.preloadImages(content.popoverContents, 'picture', function() {});
                    }
                    return received;
                });
        }

        function showPopoverContent() {
            $mdDialog.show({
                controller: 'PopoverController',
                controllerAs: 'vm',
                templateUrl: 'app/popover/popover.html',
                parent: angular.element($document.body),
                clickOutsideToClose: true,
                scope: $rootScope.$new()
            });
        }
    }
})();
