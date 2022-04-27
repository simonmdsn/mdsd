/**
 * generated by Xtext 2.25.0
 */
package dk.sdu.mmmi.mdsd.math;


/**
 * <!-- begin-user-doc -->
 * A representation of the model object '<em><b>Parenthesis</b></em>'.
 * <!-- end-user-doc -->
 *
 * <p>
 * The following features are supported:
 * </p>
 * <ul>
 *   <li>{@link dk.sdu.mmmi.mdsd.math.Parenthesis#getExpreesion <em>Expreesion</em>}</li>
 * </ul>
 *
 * @see dk.sdu.mmmi.mdsd.math.MathPackage#getParenthesis()
 * @model
 * @generated
 */
public interface Parenthesis extends Expression
{
  /**
   * Returns the value of the '<em><b>Expreesion</b></em>' containment reference.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @return the value of the '<em>Expreesion</em>' containment reference.
   * @see #setExpreesion(Expression)
   * @see dk.sdu.mmmi.mdsd.math.MathPackage#getParenthesis_Expreesion()
   * @model containment="true"
   * @generated
   */
  Expression getExpreesion();

  /**
   * Sets the value of the '{@link dk.sdu.mmmi.mdsd.math.Parenthesis#getExpreesion <em>Expreesion</em>}' containment reference.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @param value the new value of the '<em>Expreesion</em>' containment reference.
   * @see #getExpreesion()
   * @generated
   */
  void setExpreesion(Expression value);

} // Parenthesis
