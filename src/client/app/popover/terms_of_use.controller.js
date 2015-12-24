(function () {
    'use strict';

    angular
        .module('app.popover')
        .controller('TermsOfUseController', TermsOfUseController);

    TermsOfUseController.$inject = [
        '$state', 'logger', 'requestservice', '$stateParams',
        '$q', '$mdDialog', '$'
    ];
    /* @ngInject */
    function TermsOfUseController($state, logger, requestservice, $stateParams, $q, $mdDialog, $) {
        var vm = this;

        vm.menu = {
            close: closeDialog
        };

        activate();

        function activate() {
        }

        function closeDialog() {
            $mdDialog.hide();
        }
    }
})();
