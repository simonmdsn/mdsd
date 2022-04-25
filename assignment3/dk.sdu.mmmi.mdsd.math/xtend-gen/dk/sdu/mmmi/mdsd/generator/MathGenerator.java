/**
 * generated by Xtext 2.25.0
 */
package dk.sdu.mmmi.mdsd.generator;

import com.google.common.collect.Iterables;
import com.google.common.collect.Iterators;
import dk.sdu.mmmi.mdsd.math.Binding;
import dk.sdu.mmmi.mdsd.math.Div;
import dk.sdu.mmmi.mdsd.math.LetBinding;
import dk.sdu.mmmi.mdsd.math.MathExp;
import dk.sdu.mmmi.mdsd.math.MathNumber;
import dk.sdu.mmmi.mdsd.math.Minus;
import dk.sdu.mmmi.mdsd.math.Mult;
import dk.sdu.mmmi.mdsd.math.Plus;
import dk.sdu.mmmi.mdsd.math.VarBinding;
import dk.sdu.mmmi.mdsd.math.VariableUse;
import java.util.Arrays;
import java.util.HashMap;
import java.util.Map;
import java.util.Set;
import javax.swing.JOptionPane;
import org.eclipse.emf.common.util.EList;
import org.eclipse.emf.ecore.EObject;
import org.eclipse.emf.ecore.resource.Resource;
import org.eclipse.xtend2.lib.StringConcatenation;
import org.eclipse.xtext.generator.AbstractGenerator;
import org.eclipse.xtext.generator.IFileSystemAccess2;
import org.eclipse.xtext.generator.IGeneratorContext;
import org.eclipse.xtext.xbase.lib.IteratorExtensions;

/**
 * Generates code from your model files on save.
 * 
 * See https://www.eclipse.org/Xtext/documentation/303_runtime_concepts.html#code-generation
 */
@SuppressWarnings("all")
public class MathGenerator extends AbstractGenerator {
  private static Map<String, Integer> variables;
  
  @Override
  public void doGenerate(final Resource resource, final IFileSystemAccess2 fsa, final IGeneratorContext context) {
    final MathExp math = Iterators.<MathExp>filter(resource.getAllContents(), MathExp.class).next();
    final Map<String, Integer> result = MathGenerator.compute(math);
    this.displayPanel(result);
    Iterable<MathExp> _filter = Iterables.<MathExp>filter(IteratorExtensions.<EObject>toIterable(resource.getAllContents()), MathExp.class);
    for (final MathExp e : _filter) {
      String _string = e.getName().toString();
      String _plus = (_string + ".java");
      fsa.generateFile(_plus, this.compile(e));
    }
  }
  
  private CharSequence compile(final MathExp mathexp) {
    StringConcatenation _builder = new StringConcatenation();
    _builder.append("\t");
    _builder.append("package match_expression;");
    _builder.newLine();
    _builder.append("\t");
    _builder.newLine();
    _builder.append("\t");
    _builder.append("public class ");
    String _name = mathexp.getName();
    _builder.append(_name, "\t");
    _builder.append(" {");
    _builder.newLineIfNotEmpty();
    {
      EList<VarBinding> _variables = mathexp.getVariables();
      for(final VarBinding exp : _variables) {
        _builder.append("\t\t");
        _builder.append("public int ");
        String _name_1 = exp.getName();
        _builder.append(_name_1, "\t\t");
        _builder.append(";");
        _builder.newLineIfNotEmpty();
      }
    }
    _builder.newLine();
    _builder.append("\t");
    _builder.newLine();
    _builder.append("\t\t");
    _builder.append("public void compute() {");
    _builder.newLine();
    {
      EList<VarBinding> _variables_1 = mathexp.getVariables();
      for(final VarBinding exp_1 : _variables_1) {
        _builder.append("\t\t\t");
        String _name_2 = exp_1.getName();
        _builder.append(_name_2, "\t\t\t");
        _builder.append(" = ");
        String _computeExpressionString = MathGenerator.computeExpressionString(exp_1);
        _builder.append(_computeExpressionString, "\t\t\t");
        _builder.append(";");
        _builder.newLineIfNotEmpty();
      }
    }
    _builder.append("\t\t");
    _builder.append("}");
    _builder.newLine();
    _builder.append("\t");
    _builder.append("}");
    _builder.newLine();
    return _builder;
  }
  
  public void displayPanel(final Map<String, Integer> result) {
    String resultString = "";
    Set<Map.Entry<String, Integer>> _entrySet = result.entrySet();
    for (final Map.Entry<String, Integer> entry : _entrySet) {
      String _resultString = resultString;
      String _key = entry.getKey();
      String _plus = ("var " + _key);
      String _plus_1 = (_plus + " = ");
      Integer _value = entry.getValue();
      String _plus_2 = (_plus_1 + _value);
      String _plus_3 = (_plus_2 + "\n");
      resultString = (_resultString + _plus_3);
    }
    JOptionPane.showMessageDialog(null, resultString, "Math Language", JOptionPane.INFORMATION_MESSAGE);
  }
  
  public static Map<String, Integer> compute(final MathExp math) {
    Map<String, Integer> _xblockexpression = null;
    {
      HashMap<String, Integer> _hashMap = new HashMap<String, Integer>();
      MathGenerator.variables = _hashMap;
      EList<VarBinding> _variables = math.getVariables();
      for (final VarBinding varBinding : _variables) {
        MathGenerator.computeExpression(varBinding);
      }
      _xblockexpression = MathGenerator.variables;
    }
    return _xblockexpression;
  }
  
  protected static String _computeExpressionString(final VarBinding binding) {
    return MathGenerator.computeExpressionString(binding.getExpression());
  }
  
  protected static String _computeExpressionString(final MathNumber exp) {
    return Integer.valueOf(exp.getValue()).toString();
  }
  
  protected static String _computeExpressionString(final Plus exp) {
    String _computeExpressionString = MathGenerator.computeExpressionString(exp.getLeft());
    String _plus = (_computeExpressionString + " + ");
    String _computeExpressionString_1 = MathGenerator.computeExpressionString(exp.getRight());
    return (_plus + _computeExpressionString_1);
  }
  
  protected static String _computeExpressionString(final Minus exp) {
    String _computeExpressionString = MathGenerator.computeExpressionString(exp.getLeft());
    String _plus = (_computeExpressionString + " - ");
    String _computeExpressionString_1 = MathGenerator.computeExpressionString(exp.getRight());
    return (_plus + _computeExpressionString_1);
  }
  
  protected static String _computeExpressionString(final Mult exp) {
    String _computeExpressionString = MathGenerator.computeExpressionString(exp.getLeft());
    String _plus = (_computeExpressionString + " * ");
    String _computeExpressionString_1 = MathGenerator.computeExpressionString(exp.getRight());
    return (_plus + _computeExpressionString_1);
  }
  
  protected static String _computeExpressionString(final Div exp) {
    String _computeExpressionString = MathGenerator.computeExpressionString(exp.getLeft());
    String _plus = (_computeExpressionString + " / ");
    String _computeExpressionString_1 = MathGenerator.computeExpressionString(exp.getRight());
    return (_plus + _computeExpressionString_1);
  }
  
  protected static String _computeExpressionString(final LetBinding exp) {
    return MathGenerator.computeExpressionString(exp.getBody());
  }
  
  public static String computeBindingString(final LetBinding binding) {
    return MathGenerator.computeExpressionString(binding.getBinding());
  }
  
  protected static int _computeExpression(final VarBinding binding) {
    MathGenerator.variables.put(binding.getName(), Integer.valueOf(MathGenerator.computeExpression(binding.getExpression())));
    return (MathGenerator.variables.get(binding.getName())).intValue();
  }
  
  protected static int _computeExpression(final MathNumber exp) {
    return exp.getValue();
  }
  
  protected static int _computeExpression(final Plus exp) {
    int _computeExpression = MathGenerator.computeExpression(exp.getLeft());
    int _computeExpression_1 = MathGenerator.computeExpression(exp.getRight());
    return (_computeExpression + _computeExpression_1);
  }
  
  protected static int _computeExpression(final Minus exp) {
    int _computeExpression = MathGenerator.computeExpression(exp.getLeft());
    int _computeExpression_1 = MathGenerator.computeExpression(exp.getRight());
    return (_computeExpression - _computeExpression_1);
  }
  
  protected static int _computeExpression(final Mult exp) {
    int _computeExpression = MathGenerator.computeExpression(exp.getLeft());
    int _computeExpression_1 = MathGenerator.computeExpression(exp.getRight());
    return (_computeExpression * _computeExpression_1);
  }
  
  protected static int _computeExpression(final Div exp) {
    int _computeExpression = MathGenerator.computeExpression(exp.getLeft());
    int _computeExpression_1 = MathGenerator.computeExpression(exp.getRight());
    return (_computeExpression / _computeExpression_1);
  }
  
  protected static int _computeExpression(final LetBinding exp) {
    return MathGenerator.computeExpression(exp.getBody());
  }
  
  protected static int _computeExpression(final VariableUse exp) {
    return MathGenerator.computeBinding(exp.getRef());
  }
  
  protected static int _computeBinding(final VarBinding binding) {
    Integer _xblockexpression = null;
    {
      boolean _containsKey = MathGenerator.variables.containsKey(binding.getName());
      boolean _not = (!_containsKey);
      if (_not) {
        MathGenerator.computeExpression(binding);
      }
      _xblockexpression = MathGenerator.variables.get(binding.getName());
    }
    return (_xblockexpression).intValue();
  }
  
  protected static int _computeBinding(final LetBinding binding) {
    return MathGenerator.computeExpression(binding.getBinding());
  }
  
  public static String computeExpressionString(final EObject exp) {
    if (exp instanceof Div) {
      return _computeExpressionString((Div)exp);
    } else if (exp instanceof LetBinding) {
      return _computeExpressionString((LetBinding)exp);
    } else if (exp instanceof MathNumber) {
      return _computeExpressionString((MathNumber)exp);
    } else if (exp instanceof Minus) {
      return _computeExpressionString((Minus)exp);
    } else if (exp instanceof Mult) {
      return _computeExpressionString((Mult)exp);
    } else if (exp instanceof Plus) {
      return _computeExpressionString((Plus)exp);
    } else if (exp instanceof VarBinding) {
      return _computeExpressionString((VarBinding)exp);
    } else {
      throw new IllegalArgumentException("Unhandled parameter types: " +
        Arrays.<Object>asList(exp).toString());
    }
  }
  
  public static int computeExpression(final EObject exp) {
    if (exp instanceof Div) {
      return _computeExpression((Div)exp);
    } else if (exp instanceof LetBinding) {
      return _computeExpression((LetBinding)exp);
    } else if (exp instanceof MathNumber) {
      return _computeExpression((MathNumber)exp);
    } else if (exp instanceof Minus) {
      return _computeExpression((Minus)exp);
    } else if (exp instanceof Mult) {
      return _computeExpression((Mult)exp);
    } else if (exp instanceof Plus) {
      return _computeExpression((Plus)exp);
    } else if (exp instanceof VarBinding) {
      return _computeExpression((VarBinding)exp);
    } else if (exp instanceof VariableUse) {
      return _computeExpression((VariableUse)exp);
    } else {
      throw new IllegalArgumentException("Unhandled parameter types: " +
        Arrays.<Object>asList(exp).toString());
    }
  }
  
  public static int computeBinding(final Binding binding) {
    if (binding instanceof LetBinding) {
      return _computeBinding((LetBinding)binding);
    } else if (binding instanceof VarBinding) {
      return _computeBinding((VarBinding)binding);
    } else {
      throw new IllegalArgumentException("Unhandled parameter types: " +
        Arrays.<Object>asList(binding).toString());
    }
  }
}