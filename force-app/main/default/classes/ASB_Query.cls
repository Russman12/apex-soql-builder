/**
 * Encompasses concerns relating to any type of query.
 * @author Russell Laboe
 */
public abstract with sharing class ASB_Query {
  protected ASB_Select asbSelect;
  protected final ASB_From asbFrom;
  protected ASB_Where asbWhere;
  protected ASB_OrderBy asbOrderBy;
  protected ASB_Limit asbLimit;

  protected virtual ASB_Clause[] getClauses() {
    return new List<ASB_Clause>{ this.asbSelect, this.asbFrom, this.asbWhere, this.asbOrderBy, this.asbLimit };
  }

  protected ASB_Query(ASB_From asbFrom) {
    this.asbFrom = asbFrom;
    this.asbSelect = new ASB_Select().field(asbFrom.sObjType.getDescribe().fields.getMap().get('Id'));
  }

  protected virtual ASB_Query setSelect(ASB_Select asbSelect) {
    this.asbSelect = asbSelect;
    return this;
  }

  protected virtual ASB_Query setWhere(ASB_Where asbWhere) {
    this.asbWhere = asbWhere;
    return this;
  }

  protected virtual ASB_Query setOrderBy(ASB_OrderBy asbOrderBy) {
    this.asbOrderBy = asbOrderBy;
    return this;
  }

  protected virtual ASB_Query setLimit(Integer limitx) {
    this.asbLimit = new ASB_Limit(limitx);
    return this;
  }

  private abstract Detail queryDetail();

  public class Detail {
    private String queryString;
    private Map<String, Object> bindings;

    public Detail(String queryString, Map<String, Object> bindings) {
      this.queryString = queryString;
      this.bindings = bindings;
    }

    public String getQueryString() {
      return this.queryString;
    }

    public Map<String, Object> getBindings() {
      return this.bindings;
    }
  }
}
