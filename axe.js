// # Code copied from https://www.sitepoint.com/automated-accessibility-checking-with-axe/

const axeBuilder = require('axe-webdriverjs');
const webDriver = require('selenium-webdriver');

// create a PhantomJS WebDriver instance
const driver = new webDriver.Builder()
    .forBrowser('phantomjs')
    .build();

// run the tests and output the results in the console
driver
    .get('http://localhost:3000')
    .then( () => {
        axeBuilder(driver)
            .analyze((results) => {
                console.log(results);
            });
    });
