import ballerina/sql;
import ballerina/h2;

sql:PoolOptions properties = { maximumPoolSize: 1,
    idleTimeout: 600000, connectionTimeout: 30000, autoCommit: true, maxLifetime: 1800000,
    minimumIdle: 1, validationTimeout: 5000,
    connectionInitSql: "SELECT 1" };

map propertiesMap = { "AUTO_RECONNECT": "TRUE" };
sql:PoolOptions properties3 = { dataSourceClassName: "org.h2.jdbcx.JdbcDataSource" };

map propertiesMap2 = { "AUTO_RECONNECT": "TRUE" };
sql:PoolOptions properties4 = { dataSourceClassName: "org.h2.jdbcx.JdbcDataSource" };

sql:PoolOptions properties5 = { dataSourceClassName: "org.h2.jdbcx.JdbcDataSource" };

map propertiesMap3 = { "AUTO_RECONNECT": "TRUE" };
sql:PoolOptions properties6 = { dataSourceClassName: "org.h2.jdbcx.JdbcDataSource" };

function testConnectionPoolProperties1() returns (json) {
    endpoint h2:Client testDB {
        path: "./target/tempdb/",
        name: "TEST_SQL_CONNECTOR_INIT",
        username: "SA",
        password: "",
        poolOptions: { maximumPoolSize: 1 }
    };

    table dt = check testDB->select("SELECT  FirstName from Customers where registrationID = 1", ());

    json j = check <json>dt;
    testDB.stop();
    return j;
}

function testConnectionPoolProperties2() returns (json) {
    endpoint h2:Client testDB {
        path: "./target/tempdb/",
        name: "TEST_SQL_CONNECTOR_INIT",
        username: "SA",
        poolOptions: properties
    };


    table dt = check testDB->select("SELECT  FirstName from Customers where registrationID = 1", ());

    json j = check <json>dt;
    testDB.stop();
    return j;
}

function testConnectionPoolProperties3() returns (json) {
    endpoint h2:Client testDB {
        path: "./target/tempdb/",
        name: "TEST_SQL_CONNECTOR_INIT",
        username: "SA"
    };

    table dt = check testDB->select("SELECT  FirstName from Customers where registrationID = 1", ());

    json j = check <json>dt;
    testDB.stop();
    return j;
}


function testConnectorWithDefaultPropertiesForListedDB() returns (json) {
    endpoint h2:Client testDB {
        path: "./target/tempdb/",
        name: "TEST_SQL_CONNECTOR_INIT",
        username: "SA",
        poolOptions: { }
    };

    table dt = check testDB->select("SELECT  FirstName from Customers where registrationID = 1", ());

    json j = check <json>dt;
    testDB.stop();
    return j;
}

function testConnectorWithWorkers() returns (json) {
    endpoint h2:Client testDB {
        path: "./target/tempdb/",
        name: "TEST_SQL_CONNECTOR_INIT",
        username: "SA",
        poolOptions: { }
    };

    worker w1 {
        int x = 0;
        json y;

        table dt = check testDB->select("SELECT  FirstName from Customers where registrationID = 1", ());

        json j = check <json>dt;
        testDB.stop();
        return j;
    }
    worker w2 {
        int x = 10;
    }
}

function testConnectorWithDataSourceClass() returns (json) {
    endpoint h2:Client testDB {
        path: "./target/tempdb/",
        name: "TEST_SQL_CONNECTOR_INIT",
        username: "SA",
        poolOptions: properties3,
        dbOptions: propertiesMap
    };

    table dt = check testDB->select("SELECT  FirstName from Customers where registrationID = 1", ());

    json j = check <json>dt;
    testDB.stop();
    return j;
}

function testConnectorWithDataSourceClassAndProps() returns (json) {
    endpoint h2:Client testDB {
        path: "./target/tempdb/",
        name: "TEST_SQL_CONNECTOR_INIT",
        username: "SA",
        password: "",
        poolOptions: properties4,
        dbOptions: propertiesMap2
    };

    table dt = check testDB->select("SELECT  FirstName from Customers where registrationID = 1", ());

    json j = check <json>dt;
    testDB.stop();
    return j;
}

function testConnectorWithDataSourceClassWithoutURL() returns (json) {
    endpoint h2:Client testDB {
        path: "./target/tempdb/",
        name: "TEST_SQL_CONNECTOR_INIT",
        username: "SA",
        password: "",
        poolOptions: properties5
    };


    table dt = check testDB->select("SELECT  FirstName from Customers where registrationID = 1", ());

    json j = check <json>dt;
    testDB.stop();
    return j;
}

function testConnectorWithDataSourceClassURLPriority() returns (json) {
    endpoint h2:Client testDB {
        path: "./target/tempdb/",
        name: "TEST_SQL_CONNECTOR_INIT",
        username: "SA",
        password: "",
        poolOptions: properties6,
        dbOptions: propertiesMap3
    };


    table dt = check testDB->select("SELECT  FirstName from Customers where registrationID = 1", ());

    json j = check <json>dt;
    testDB.stop();
    return j;
}


function testPropertiesGetUsedOnlyIfDataSourceGiven() returns (json) {
    endpoint h2:Client testDB {
        path: "./target/tempdb/",
        name: "TEST_SQL_CONNECTOR_INIT",
        username: "SA",
        password: "",
        poolOptions: { maximumPoolSize: 1 },
        dbOptions: { "invalidProperty": 109 }
    };

    table dt = check testDB->select("SELECT  FirstName from Customers where registrationID = 1", ());

    json j = check <json>dt;
    testDB.stop();
    return j;
}

function testConnectionFailure() {
    endpoint h2:Client testDB {
        path: "./target/tempdb/",
        name: "NON_EXISTING_DB",
        username: "SA",
        password: "",
        poolOptions: { maximumPoolSize: 1 },
        dbOptions: { "IFEXISTS": true }
    };

}
