/**
 * @description SOQL Query builder.<br /> <br />
 * This class is used to generate a new SOQL builder and encompasses the high level building responsibilities.
 * It is a singelton factory used to create a SOQL builder. The builder can then be used to procedurally build a query.
 * Once built, the SOQL can then be executed by calling `query()` or converted to a query string by calling `queryString()`.
 *
 * @example
 * ASB_SOQL.SOQL soql = ASB_SOQL.instance()
 *   .builder(Account.getSObjectType())
 *   .selectx(Account.Name)
 *   .selectx(Account.AccountNumber)
 *   .limitx(10)
 *   .wherex(new ASB_Where(Account.Type, ASB_Where.ComparisonOperator.EQUALS, 'Customer'))
 *   .build();
 *
 * List<Account> accs = soql.query();
 * System.debug(accs);
 *
 * @author Russell Laboe
 * @group Apex SOQL Builder
 */
public with sharing class ASB_SOQL {
  private static final System.AccessLevel DEFAULT_ACCESS_LEVEL = System.AccessLevel.SYSTEM_MODE;
  private static ASB_SOQL instance;

  @TestVisible
  private static ASB_Select asbSelect = ASB_Select.instance();
  @TestVisible
  private static ASB_From asbFrom = ASB_From.instance();
  @TestVisible
  private static ASB_Limit asbLimit = ASB_Limit.instance();

  /**
   * Returns singleton instance of ASB_SOQL builder factory
   * @return  `ASB_SOQL`
   */
  public static ASB_SOQL instance() {
    if (instance == null) {
      instance = new ASB_SOQL();
    }
    return instance;
  }

  /**
   * private constructor to prevent external class instantiation
   */
  private ASB_SOQL() {
  }

  /**
   * Constructs new builder instance for given `SObjectType`
   * @param fromSObjType SObjectType for which builder to be constructed
   * @return  `Builder`
   */
  public Buildable builder(SObjectType fromSObjType) {
    return new Builder(fromSObjType);
  }

  public interface Queryable {
    /**
     * Returns query as string
     */
    String queryString();

    /**
     * Performs SOQL query
     */
    List<SObject> query();
    List<SObject> query(Map<String, Object> bindMap);
    SObject querySingle();
    SObject querySingle(Map<String, Object> bindMap);
  }

  public interface Buildable {
    /**
     * add select elements to statement
     */
    Buildable selectx(ASB_Select.Elements selectElements);
    Buildable selectx(SObjectField field);
    Buildable selectx(SObjectField relationshipField, SObjectField field);

    /**
     * set where element
     */
    Buildable wherex(ASB_Where.Expression whereClause);

    /**
     * set limit element
     */
    Buildable limitx(Integer limitx);

    /**
     * Set query access level
     */
    Buildable accessLevel(System.AccessLevel accessLevel);

    /**
     * build SOQL object
     */
    Queryable build();
  }

  /**
   * Builder responsibile for procedural construction of SOQL. This class should be constructed from the top
   * level factory instance like `ASB_SOQL.instance().builder(Account.getSObjectType())`
   */
  private class Builder implements Buildable {
    private ASB_Select.Elements selectElements;
    private final ASB_SOQLClause fromClause;
    private ASB_Where.Expression expression;
    private ASB_SOQLClause limitClause;
    private System.AccessLevel accessLevel = DEFAULT_ACCESS_LEVEL;

    private Builder(SObjectType fromSObjType) {
      this.fromClause = asbFrom.clause(fromSObjType);
      this.selectElements = asbSelect.make(fromSObjType);
    }

    public Builder selectx(SObjectField field) {
      this.selectElements = this.selectElements.add(field);
      return this;
    }

    public Builder selectx(SObjectField relationshipField, SObjectField field) {
      this.selectElements = this.selectElements.add(relationshipField, field);
      return this;
    }

    public Builder selectx(ASB_Select.Elements selectElements) {
      this.selectElements = this.selectElements.combine(selectElements);
      return this;
    }

    /**
     * Sets the WHERE clause
     * @param conditionExpression ASB_Where.ConditionExpression which represents clause
     * @return  `Builder`
     */
    public Builder wherex(ASB_Where.Expression expression) {
      this.expression = expression;
      return this;
    }

    /**
     * Sets the LIMIT clause
     * @param limitx integer value of LIMIT clause
     * @return  `Builder`
     */
    public Builder limitx(Integer limitx) {
      this.limitClause = asbLimit.clause(limitx);
      return this;
    }

    /**
     * Sets the access level for which the query should execute. Defaults to `SYSTEM_MODE`
     * @param accessLevel System.AccessLevel level to execute query
     * @return  `Builder`
     */
    public Builder accessLevel(System.AccessLevel accessLevel) {
      this.accessLevel = accessLevel;
      return this;
    }

    /**
     * Compiles builder instance into functional SOQL object
     * @return  `SOQL`
     */
    public Queryable build() {
      return new SOQL(
        this.selectElements.toClause(),
        this.fromClause,
        this.expression?.toClause(),
        this.limitClause,
        this.accessLevel
      );
    }
  }

  /**
   * This class handles the responsiblities of a SOQL query.
   */
  public class SOQL implements Queryable {
    @TestVisible
    private final List<ASB_SOQLClause> clauses;
    @TestVisible
    private final AccessLevel accessLevel;

    /**
     * All inclusive constructor for setting the various clause elements of the SOQL,
     * as well as other details pertinent to performing a query
     * @param selectx SELECT clause element
     * @param fromx FROM clause element
     * @param wherex WHERE clause element
     * @param limitx LIMIT clause element
     * @param accessLevel accessLevel used when executing query
     */
    private SOQL(
      ASB_SOQLClause selectx,
      ASB_SOQLClause fromx,
      ASB_SOQLClause wherex,
      ASB_SOQLClause limitx,
      System.AccessLevel accessLevel
    ) {
      this.clauses = new List<ASB_SOQLClause>{ selectx, fromx, wherex, limitx };
      this.accessLevel = accessLevel;
    }

    /**
     * Returns SOQL instance as a query string
     * @return  `String`
     */
    public String queryString() {
      String queryStr = '';
      for (ASB_SOQLClause clause : this.clauses) {
        if (clause != null) {
          queryStr += clause.toClauseString() + ' ';
        }
      }

      return queryStr.trim();
    }

    /**
     * Returns list of SObject results from SOQL query
     * @return  `List<SObject>`
     */
    public List<SObject> query() {
      return Database.query(this.queryString(), this.accessLevel);
    }

    /**
     * Returns list of SObject reults from SOQL query with given bindings
     * @param bindMap Map<String, Object> bind mappings
     * @return  `List<SObject>`
     */
    public List<SObject> query(Map<String, Object> bindMap) {
      return Database.queryWithBinds(this.queryString(), bindMap, this.accessLevel);
    }

    /**
     * Returns a single SObject result from SOQL query
     * @return  `SObject`
     */
    public SObject querySingle() {
      return Database.query(this.queryString(), this.accessLevel);
    }

    /**
     * Returns a single SObject result from SOQL query with given bindings
     * @param bindMap Map<String, Object> bind mappings
     * @return  `SObject`
     */
    public SObject querySingle(Map<String, Object> bindMap) {
      return Database.queryWithBinds(this.queryString(), bindMap, this.accessLevel);
    }
  }
}
