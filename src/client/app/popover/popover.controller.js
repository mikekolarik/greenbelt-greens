(function () {
    'use strict';

    angular
        .module('app.popover')
        .controller('PopoverController', PopoverController);

    PopoverController.$inject = [
        '$state', 'logger', 'requestservice', '$stateParams',
        '$q', '$mdDialog', 'PopoverContent', '$'
    ];
    /* @ngInject */
    function PopoverController($state, logger, requestservice, $stateParams, $q, $mdDialog, PopoverContent, $) {
        var vm = this;

        vm.menu = {
            close: closeDialog,

            carouselNext: carouselNext,
            carouselPrev: carouselPrev
        };

        vm.model = {
            popoverContent: PopoverContent
        };

        activate();

        function activate() {
        }

        function closeDialog() {
            $mdDialog.hide();
        }

        function carouselNext() {
            var owl = $('#content-carousel');
            owl.trigger('next.owl.carousel');
        }

        function carouselPrev() {
            var owl = $('#content-carousel');
            owl.trigger('prev.owl.carousel');
        }
    }
})();
