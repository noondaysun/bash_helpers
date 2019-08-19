const merchantJson = require('../fixtures/merchants');

context('merchants', () => {
    it('per merchant google serp icon', () => {
        let merchants = Object.values(merchantJson.merchants);
        merchants.forEach(function(record) {
            let uri = 'https://www.google.co.uk/search?source=hp&ei=_9FSXYL1Cs6dkwW-lrrADg&q=' + record.name + '&oq=' + record.name;
            console.log('Checking ' + uri);

            cy.request(uri);
            cy.document().its('contentType').should('eq', 'text/html');
            /** TODO figure out how to bring in  */
            // cy.contains('#rso > div > div > div:nth-child(1) > div > div > div.r > span.serp-2U0RCK');
        });
    });
});