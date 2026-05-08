LOAD CSV WITH HEADERS FROM 'file:///data-2.csv' AS row
CREATE (:Customer {
    id: toInteger(row.customer_id),
    firstName: row.first_name,
    lastName: row.last_name,
    age: toInteger(row.age),
    gender: row.gender,
    city: row.city,
    email: row.email_address
});

LOAD CSV WITH HEADERS FROM 'file:///data-2.csv' AS row
MERGE (:Branch {
    id: toInteger(row.branch_id),
    name: row.branch_name
});

LOAD CSV WITH HEADERS FROM 'file:///data-2.csv' AS row
MATCH (c:Customer {id: toInteger(row.customer_id)})
MATCH (b:Branch {id: toInteger(row.branch_id)})

// Création du noeud Transaction
CREATE (t:Transaction {
    id: toInteger(row.transaction_id),
    amount: toFloat(row.transaction_amount),
    date: row.transaction_date,
    isAnomaly: toInteger(row.anomaly)
})

// Liaison Transaction -> Branche (pour savoir où elle a eu lieu)
CREATE (t)-[:OCCURRED_AT]->(b)

// Liaisons spécifiques selon le type de transaction
FOREACH (_ IN CASE WHEN row.transaction_type = 'Withdrawal' THEN [1] ELSE [] END |
    CREATE (c)-[:MADE_WITHDRAWAL]->(t))
FOREACH (_ IN CASE WHEN row.transaction_type = 'Deposit' THEN [1] ELSE [] END |
    CREATE (c)-[:MADE_DEPOSIT]->(t))
FOREACH (_ IN CASE WHEN row.transaction_type = 'Transfer' THEN [1] ELSE [] END |
    CREATE (c)-[:MADE_TRANSFER]->(t))


LOAD CSV WITH HEADERS FROM 'file:///data-2.csv' AS row
MATCH (c:Customer {id: toInteger(row.customer_id)})
// On crée un seul noeud par type de prêt (ex: "Mortgage")
MERGE (lt:LoanType {name: row.loan_type})
// On lie le client au type, et on met les détails du prêt sur le lien
CREATE (c)-[:BORROWED {
    loan_id: toInteger(row.loan_id),
    amount: toFloat(row.loan_amount),
    status: row.loan_status
}]->(lt);


LOAD CSV WITH HEADERS FROM 'file:///data-2.csv' AS row
MATCH (c:Customer {id: toInteger(row.customer_id)})
MERGE (ct:CardType {name: row.card_type})
CREATE (c)-[:HOLDS_CARD {
    card_id: toInteger(row.card_id),
    limit: toFloat(row.credit_limit)
}]->(ct);