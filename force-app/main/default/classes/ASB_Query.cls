public abstract class ASB_Query {
  private static final System.AccessLevel DEFAULT_ACCESS_LEVEL = System.AccessLevel.SYSTEM_MODE;

  protected ASB_Select asbSelect;
  protected final ASB_From asbFrom;
  protected ASB_Where asbWhere;
  protected ASB_OrderBy asbOrder;
  protected ASB_Limit asbLimit;

  public System.AccessLevel accessLevel = DEFAULT_ACCESS_LEVEL;

  protected ASB_Query(ASB_From asbFrom) {
    this.asbFrom = asbFrom;
    this.asbSelect = new ASB_Select();
  }

  protected virtual ASB_Query superSelect(ASB_Select asbSelect) {
    this.asbSelect = asbSelect;
    return this;
  }

  protected virtual ASB_Query superWhere(ASB_Where asbWhere) {
    this.asbWhere = asbWhere;
    return this;
  }

  protected virtual ASB_Query superOrderBy(ASB_OrderBy asbOrder) {
    this.asbOrder = asbOrder;
    return this;
  }

  protected virtual ASB_Query superLimit(Integer limitx) {
    this.asbLimit = new ASB_Limit(limitx);
    return this;
  }

  private abstract String soqlString();
}
