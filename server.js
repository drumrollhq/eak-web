'use strict';

const hapi = require('hapi');
const inert = require('inert');
const good = require('good');

const server = new hapi.Server();
server.connection({port: process.env.PORT || 5000});
server.register(inert);
server.register({
    register: good,
    options: {
        reporters: {
            console: [{
                module: 'good-squeeze',
                name: 'Squeeze',
                args: [{
                    response: '*',
                    log: '*'
                }]
            },
                {
                    module: 'good-console'
                },
                'stdout'
            ]
        }
    }
});

// Add the route
server.route({
    method: 'GET',
    path:'/{param*}',
    handler: {
        directory: {
            path: 'public',
            index: true
        }
    }
});

// Start the server
server.start((err) => {

    if (err) {
        throw err;
    }

    server.log('info', `Server running at: ${server.info.uri}`);

});
