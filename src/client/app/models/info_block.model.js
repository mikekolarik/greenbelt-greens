(function () {
    'use strict';

    angular
        .module('app.core')
        .factory('InfoBlock', InfoBlock);

    InfoBlock.$inject = ['requestservice', '$mdDialog', '$document', '$rootScope'];
    /* @ngInject */
    function InfoBlock(requestservice, $mdDialog, $document, $rootScope) {
        var infoBlock;

        infoBlock = {
            infoBlocksHash: {},
            api: {
                loadInfoBlocks: loadInfoBlocks,
                getInfoByKey: getInfoByKey
            }
        };

        return infoBlock;

        function loadInfoBlocks() {
            if (Object.keys(infoBlock.infoBlocksHash).length === 0) {
                return requestservice.run('getInfoBlocks', {})
                    .then(function (received) {
                        console.log('Info blocks loaded');
                        console.log(received);
                        if (received.data.success === 0) {
                            parseInfoBlocksToHash(received.data.result);
                        }
                        return received;
                    });
            }
        }

        function parseInfoBlocksToHash(list) {
            list.forEach(function(item) {
                infoBlock.infoBlocksHash[item.key] = item.description;
            });
        }

        function getInfoByKey(key) {
            return infoBlock.infoBlocksHash[key] || key;
        }
    }
})();
