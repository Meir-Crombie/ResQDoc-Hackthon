//Creating the connection block to connect to the databas
import Pool from "pg";
const pool = new Pool({
  user: "postgres",
  host: "",
  database: "resqdoc",
  password: "resqdoc",
  port: 5432,
});

module.exports = pool;
