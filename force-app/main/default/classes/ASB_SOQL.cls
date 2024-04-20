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
  public Builder builder(SObjectType fromSObjType) {
    return new Builder(fromSObjType);
  }

  /**
   * This class handles the responsiblities of a SOQL query.
   */
  public class SOQL {
    private final List<Clause> clauses;
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
      ASB_Select selectx,
      ASB_From fromx,
      ASB_Where wherex,
      ASB_Limit limitx,
      System.AccessLevel accessLevel
    ) {
      this.clauses = new List<Clause>{ selectx, fromx, wherex, limitx };
      this.accessLevel = accessLevel;
    }

    /**
     * Returns SOQL instance as a query string
     * @return  `String`
     */
    public String queryString() {
      String queryStr = '';
      for (Clause clause : this.clauses) {
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

  /**
   * Builder responsibile for procedural construction of SOQL. This class should be constructed from the top
   * level factory instance like `ASB_SOQL.instance().builder(Account.getSObjectType())`
   */
  public class Builder {
    private final ASB_Select selectElements;
    private final ASB_From fromSObjectType;
    private ASB_Where whereClause;
    private ASB_Limit limitx;
    private System.AccessLevel accessLevel = DEFAULT_ACCESS_LEVEL;

    /**
     * Creates new Builder instance for given SObjectType. This is private as it should only be
     * constructed from the top level factory instance.
     * @param fromSObjType SObjectType for which SOQL should be built
     */
    private Builder(SObjectType fromSObjType) {
      this.fromSObjectType = new ASB_From(fromSObjType);
      this.selectElements = new ASB_Select(
        new Set<ASB_Select.Element>{
          new ASB_Select.Field(fromSObjType.getDescribe().Fields.getMap().get('Id'))
        }
      );
    }

    /**
     * Adds SObjectField to SELECT clause
     * @param field SObjectField to add to select clause
     * @return  `Builder`
     */
    public Builder selectx(SObjectField field) {
      this.selectElements.add(new ASB_Select.Field(field));
      return this;
    }

    /**
     * Sets the WHERE clause
     * @param whereClause ASB_Where which represents clause
     * @return  `Builder`
     */
    public Builder wherex(ASB_Where whereClause) {
      this.whereClause = whereClause;
      return this;
    }

    /**
     * Sets the LIMIT clause
     * @param limitx integer value of LIMIT clause
     * @return  `Builder`
     */
    public Builder limitx(Integer limitx) {
      this.limitx = new ASB_Limit(limitx);
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
    public SOQL build() {
      return new SOQL(
        this.selectElements,
        this.fromSObjectType,
        this.whereClause,
        this.limitx,
        this.accessLevel
      );
    }
  }

  /**
   * A clause element used in a SOQL string.
   */
  public interface Clause {
    /**
     * Returns a complete clause as a string
     * @return  `String`
     */
    String toClauseString();
  }
}
