/**
 * Apex SOQL Builder - A type safe dynamic query executor.   Copyright (C) 2025  Russell Laboe
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <https://www.gnu.org/licenses/>.
 *
 * @class ASB_SelectEngine
 * @description Engine for building SELECT clauses for SOQL queries using Apex SOQL Builder.
 * @example
 *   ASB_SelectEngine engine = new ASB_SelectEngine(Account.SObjectType);
 *   engine.addField(Account.Name);
 *   String soql = engine.clauseString(new ASB_BindContext());
 */
public with sharing class ASB_SelectEngine {
  private final List<Element> elements = new List<Element>();
  private final Schema.SObjectType rootSObjType;

  /**
   * @apexdoc
   * @description Constructs a new ASB_SelectEngine for the given SObject type.
   * @param rootSObjType The root SObject type for the SELECT clause.
   * @example
   *   ASB_SelectEngine engine = new ASB_SelectEngine(Account.SObjectType);
   */
  public ASB_SelectEngine(Schema.SObjectType rootSObjType) {
    this.rootSObjType = rootSObjType;
  }

  /**
   * @apexdoc
   * @description Adds a field to the SELECT clause.
   * @param field Field to add to select clause.
   * @example
   *   engine.addField(Account.Name);
   */
  public void addField(Schema.SObjectField field) {
    (new FieldElement(new List<Schema.SObjectField>{ field })).mergeInto(this.elements);
  }

  /**
   * @apexdoc
   * @description Adds a parent record field to the SELECT clause.
   * @param fieldPath Path to parent field as a list of SObjectFields.
   * @example
   *   engine.addParent(new List<Schema.SObjectField>{ Opportunity.Account, Account.Name });
   */
  public void addParent(List<Schema.SObjectField> fieldPath) {
    (new FieldElement(fieldPath)).mergeInto(elements);
  }

  /**
   * @apexdoc
   * @description Adds a subquery to the SELECT clause. Throws an exception if a different subquery for the same child object is added.
   * @param subQuery Subquery to add to the select clause.
   * @example
   *   ASB_SubQueryBuilder sub = new ASB_SubQueryBuilder(...);
   *   engine.mergeSubQuery(sub);
   */
  public void mergeSubQuery(ASB_SubQueryBuilder subQuery) {
    (new SubqueryElement(subQuery)).mergeInto(this.elements);
  }

  /**
   * @apexdoc
   * @description Merges the elements of this engine into another ASB_SelectEngine instance.
   * @param targetEngine The target engine to merge into.
   * @example
   *   engine1.mergeInto(engine2);
   */
  public void mergeInto(ASB_SelectEngine targetEngine) {
    for (Element e : this.elements) {
      e.mergeInto(targetEngine.elements);
    }
  }

  /**
   * @apexdoc
   * @description Returns the SELECT clause as a query string.
   * @param ctx The bind context for query string generation.
   * @return The SELECT clause as a String.
   * @example
   *   String soql = engine.clauseString(new ASB_BindContext());
   */
  public String clauseString(ASB_BindContext ctx) {
    List<String> elementStrs = new List<String>();
    for (Element element : this.elements) {
      elementStrs.add(element.queryString(ctx));
    }

    return 'SELECT ' + String.join(elementStrs, ', ');
  }

  private interface Element {
    String queryString(ASB_BindContext ctx);
    void mergeInto(List<Element> target);
  }

  private class FieldElement implements Element {
    private final List<Schema.SObjectField> relationshipPath;
    private String cachedQueryString;

    private FieldElement(Schema.SObjectField[] relationshipPath) {
      this.relationshipPath = relationshipPath;
    }

    public String queryString(ASB_BindContext ctx) {
      if (cachedQueryString == null) {
        String[] fieldStrs = new List<String>{};
        for (Integer i = 0; i < this.relationshipPath.size() - 1; i++) {
          fieldStrs.add(this.relationshipPath[i].getDescribe().getRelationshipName());
        }
        fieldStrs.add(this.relationshipPath[this.relationshipPath.size() - 1].getDescribe().getName());
        cachedQueryString = String.join(fieldStrs, '.');
      }

      return cachedQueryString;
    }

    public void mergeInto(List<Element> target) {
      if (!target.contains(this)) {
        target.add(this);
      }
    }

    public Integer hashCode() {
      return this.relationshipPath.hashCode();
    }

    public Boolean equals(Object obj) {
      return obj instanceof FieldElement && this.relationshipPath.equals(((FieldElement) obj).relationshipPath);
    }
  }

  private class SubqueryElement implements Element {
    private final ASB_SubQueryBuilder subQuery;

    private SubqueryElement(ASB_SubQueryBuilder subQuery) {
      this.subQuery = subQuery;
    }

    public String queryString(ASB_BindContext ctx) {
      return '(' + this.subQuery.queryDetail(ctx) + ')';
    }
    public void mergeInto(List<Element> target) {
      SubqueryElement targetElement = findByRelationship(target, this.subQuery.relatedBy());

      if (targetElement == null) {
        target.add(this);
      } else {
        this.subQuery.mergeInto(targetElement.subQuery);
      }
    }

    private SubqueryElement findByRelationship(List<Element> target, ASB_FromRelationshipClause relatedBy) {
      for (Element e : target) {
        if (e instanceof SubqueryElement && ((SubqueryElement) e).subQuery.relatedBy() == relatedBy) {
          return (SubqueryElement) e;
        }
      }
      return null;
    }
  }
}
