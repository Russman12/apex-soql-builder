/**
 * Encompasses concerns relating to any type of query.
 * @author Russell Laboe
 */
public abstract class ASB_Query {
  protected ASB_Select asbSelect;
  protected final ASB_From asbFrom;
  protected ASB_Where asbWhere;
  protected ASB_OrderBy asbOrderBy;
  protected ASB_Limit asbLimit;

  protected ASB_Query(ASB_From asbFrom) {
    this.asbFrom = asbFrom;
    this.asbSelect = ASB_Select.make().field(asbFrom.sObjType.getDescribe().fields.getMap().get('Id'));
  }

  protected virtual ASB_Query superSelect(ASB_Select asbSelect) {
    this.asbSelect = asbSelect;
    return this;
  }

  protected virtual ASB_Query superWhere(ASB_Where asbWhere) {
    this.asbWhere = asbWhere;
    return this;
  }

  protected virtual ASB_Query superOrderBy(ASB_OrderBy asbOrderBy) {
    this.asbOrderBy = asbOrderBy;
    return this;
  }

  protected virtual ASB_Query superLimit(Integer limitx) {
    this.asbLimit = new ASB_Limit(limitx);
    return this;
  }

  private abstract String soqlString();
}
