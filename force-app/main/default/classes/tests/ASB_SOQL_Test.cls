/**
 * Provides unit test coverage for ASB_SOQL class
 * @author Russell Laboe
 */
@isTest
private class ASB_SOQL_Test {
  static final ASB_SOQL asbSOQL = ASB_SOQL.instance();

  static final Mock asbSelectMock = Mock.forType(ASB_Select.class);
  static final MethodSpy asbSelectMakeSpy = asbSelectMock.spyOn('make');

  static final SelectElements selectElements = new SelectElements();

  static {
    ASB_SOQL.asbSelect = (ASB_Select) asbSelectMock.stub;

    asbSelectMakeSpy.returns(selectElements);
  }

  /**
   * ensures that the instance method returns singleton instance
   */
  @isTest
  static void instanceReturnsSingletonInstance() {
    ASB_SOQL inst1 = ASB_SOQL.instance();
    ASB_SOQL inst2 = ASB_SOQL.instance();

    System.Assert.areEqual(inst1, inst2, 'instances are not the same');
  }

  /**
   * ensures that `make` is called as expected
   */
  @IsTest
  static void make() {
    //arrange
    SObjectType sObjType = Account.getSObjectType();

    //act
    ASB_SOQL.Buildable bldr = asbSOQL.builder(sObjType);

    //assert
    Expect.that(asbSelectMakeSpy).hasBeenCalledWith(sObjType);
  }

  /**
   * ensures that `builder.selectx(SObjectField field)` calls selectElements `add()` method as expected
   */
  @IsTest
  static void builderSelect1Field() {
    //arrange
    SObjectField field = Account.Name;

    //act
    ASB_SOQL.Buildable bldr = asbSOQL.builder(Account.getSObjectType()).selectx(field);

    //assert
    System.Assert.areEqual(1, selectElements.calls.get('add').size(), 'add method not called');
    System.Assert.areEqual(1, selectElements.calls.get('add')[0].size(), 'wrong add method called');
    System.Assert.areEqual(field, selectElements.calls.get('add')[0][0], 'add method not called as expected');
  }

  /**
   * ensures that `builder.selectx(SObjectField relationshipField, SObjectField field)` calls selectElements `add()` method as expected
   */
  @IsTest
  static void builderSelect2Fields() {
    //arrange
    SObjectField relField = Account.OwnerId;
    SObjectField field = User.Id;

    //act
    ASB_SOQL.Buildable bldr = asbSOQL.builder(Account.getSObjectType()).selectx(relField, field);

    //assert
    System.Assert.areEqual(1, selectElements.calls.get('add').size(), 'add method not called');
    System.Assert.areEqual(2, selectElements.calls.get('add')[0].size(), 'wrong add method called');
    System.Assert.areEqual(relField, selectElements.calls.get('add')[0][0], 'add method not called as expected');
    System.Assert.areEqual(field, selectElements.calls.get('add')[0][1], 'add method not called as expected');
  }

  /**
   * ensures that `builder.selectx(SObjectField relationshipField, SObjectField field)` calls selectElements `add()` method as expected
   */
  @IsTest
  static void builderSelectElements() {
    // arrange
    SelectElements testElements = new SelectElements();

    //act
    ASB_SOQL.Buildable bldr = asbSOQL.builder(Account.getSObjectType()).selectx(testElements);

    //assert
    System.Assert.areEqual(1, selectElements.calls.get('combine').size(), 'combine method not called');
    System.Assert.areEqual(1, selectElements.calls.get('combine')[0].size(), 'wrong combine method called');
    System.Assert.areEqual(
      testElements,
      selectElements.calls.get('combine')[0][0],
      'combine method not called as expected'
    );
  }

  /**
   * ensures that `builder.selectx(SObjectField relationshipField, SObjectField field)` calls selectElements `add()` method as expected
   */
  @IsTest
  static void builderWhere() {
    // // arrange
    // WhereExp wherex = new WhereExp();

    // //act
    // ASB_SOQL.Buildable bldr = asbSOQL.builder(Account.getSObjectType()).wherex(wherex);

    // //assert
    // System.Assert.areEqual(1, selectElements.calls.get('combine').size(), 'combine method not called');
    // System.Assert.areEqual(1, selectElements.calls.get('combine')[0].size(), 'wrong combine method called');
    // System.Assert.areEqual(
    //   testElements,
    //   selectElements.calls.get('combine')[0][0],
    //   'combine method not called as expected'
    // );
  }

  // wherex(ASB_Where.Expression whereClause)
  // limitx(Integer limitx);
  // accessLevel(System.AccessLevel accessLevel);
  // build();

  private class SelectElements implements ASB_Select.Elements {
    Map<String, List<List<Object>>> calls = new Map<String, List<List<Object>>>();

    public SelectElements add(SObjectField sObjField) {
      this.addCall('add', new List<Object>{ sObjField });
      return this;
    }
    public SelectElements add(SObjectField relationshipField, SObjectField sObjField) {
      this.addCall('add', new List<Object>{ relationshipField, sObjField });
      return this;
    }
    public SelectElements combine(ASB_Select.Elements selects) {
      this.addCall('combine', new List<Object>{ selects });
      return this;
    }
    public ASB_SOQLClause toClause() {
      this.addCall('toClause', null);
      return new Clause();
    }

    public void addCall(String methodName, List<Object> args) {
      if (!this.calls.keyset().contains(methodName)) {
        this.calls.put(methodName, new List<List<Object>>());
      }
      this.calls.get(methodName).add(args);
    }
  }

  private class Clause implements ASB_SOQLClause {
    Map<String, List<List<Object>>> calls = new Map<String, List<List<Object>>>();

    public String toClauseString() {
      this.addCall('toClauseString', null);
      return 'my clause';
    }

    public void addCall(String methodName, List<Object> args) {
      if (!this.calls.keyset().contains(methodName)) {
        this.calls.put(methodName, new List<List<Object>>());
      }
      this.calls.get(methodName).add(args);
    }
  }

  // private class WhereExp implements ASB_Where.Expression {
  //   Map<String, List<List<Object>>> calls = new Map<String, List<List<Object>>>();

  //   public WhereExp andx(ASB_Where.Expression expression) {
  //     this.addCall('andx', null);
  //     return this;
  //   }
  //   public ASB_Where.Expression andx(SObjectField field, ComparisonOperator operator, Object value) {
  //     this.addCall('andx', null);
  //     return this;
  //   }
  //   public WhereExp orx(ASB_Where.Expression expression) {
  //     this.addCall('orx', null);
  //     return this;
  //   }
  //   public ASB_Where.Expression orx(SObjectField field, ComparisonOperator operator, Object value) {
  //     this.addCall('orx', null);
  //     return this;
  //   }
  //   public WhereExp group() {
  //     this.addCall('group', null);
  //     return this;
  //   }
  //   public ASB_SOQLClause toClause() {
  //     this.addCall('toClause', null);
  //     return new Clause();
  //   }

  //   public void addCall(String methodName, List<Object> args) {
  //     if (!this.calls.keyset().contains(methodName)) {
  //       this.calls.put(methodName, new List<List<Object>>());
  //     }
  //     this.calls.get(methodName).add(args);
  //   }
  // }
}
