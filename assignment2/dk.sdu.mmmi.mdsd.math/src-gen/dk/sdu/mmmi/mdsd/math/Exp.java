/**
 * generated by Xtext 2.25.0
 */
package dk.sdu.mmmi.mdsd.math;

import org.eclipse.emf.ecore.EObject;

/**
 * <!-- begin-user-doc -->
 * A representation of the model object '<em><b>Exp</b></em>'.
 * <!-- end-user-doc -->
 *
 * <p>
 * The following features are supported:
 * </p>
 * <ul>
 *   <li>{@link dk.sdu.mmmi.mdsd.math.Exp#getLeft <em>Left</em>}</li>
 *   <li>{@link dk.sdu.mmmi.mdsd.math.Exp#getOperator <em>Operator</em>}</li>
 *   <li>{@link dk.sdu.mmmi.mdsd.math.Exp#getRight <em>Right</em>}</li>
 * </ul>
 *
 * @see dk.sdu.mmmi.mdsd.math.MathPackage#getExp()
 * @model
 * @generated
 */
public interface Exp extends EObject
{
  /**
   * Returns the value of the '<em><b>Left</b></em>' containment reference.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @return the value of the '<em>Left</em>' containment reference.
   * @see #setLeft(dk.sdu.mmmi.mdsd.math.Number)
   * @see dk.sdu.mmmi.mdsd.math.MathPackage#getExp_Left()
   * @model containment="true"
   * @generated
   */
  dk.sdu.mmmi.mdsd.math.Number getLeft();

  /**
   * Sets the value of the '{@link dk.sdu.mmmi.mdsd.math.Exp#getLeft <em>Left</em>}' containment reference.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @param value the new value of the '<em>Left</em>' containment reference.
   * @see #getLeft()
   * @generated
   */
  void setLeft(dk.sdu.mmmi.mdsd.math.Number value);

  /**
   * Returns the value of the '<em><b>Operator</b></em>' containment reference.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @return the value of the '<em>Operator</em>' containment reference.
   * @see #setOperator(ExpOp)
   * @see dk.sdu.mmmi.mdsd.math.MathPackage#getExp_Operator()
   * @model containment="true"
   * @generated
   */
  ExpOp getOperator();

  /**
   * Sets the value of the '{@link dk.sdu.mmmi.mdsd.math.Exp#getOperator <em>Operator</em>}' containment reference.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @param value the new value of the '<em>Operator</em>' containment reference.
   * @see #getOperator()
   * @generated
   */
  void setOperator(ExpOp value);

  /**
   * Returns the value of the '<em><b>Right</b></em>' containment reference.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @return the value of the '<em>Right</em>' containment reference.
   * @see #setRight(Exp)
   * @see dk.sdu.mmmi.mdsd.math.MathPackage#getExp_Right()
   * @model containment="true"
   * @generated
   */
  Exp getRight();

  /**
   * Sets the value of the '{@link dk.sdu.mmmi.mdsd.math.Exp#getRight <em>Right</em>}' containment reference.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @param value the new value of the '<em>Right</em>' containment reference.
   * @see #getRight()
   * @generated
   */
  void setRight(Exp value);

} // Exp
