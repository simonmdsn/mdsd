/*
 * generated by Xtext 2.25.0
 */
package dk.sdu.mmmi.mdsd.generator

import dk.sdu.mmmi.mdsd.math.Div
import dk.sdu.mmmi.mdsd.math.LetBinding
import dk.sdu.mmmi.mdsd.math.MathExp
import dk.sdu.mmmi.mdsd.math.MathNumber
import dk.sdu.mmmi.mdsd.math.Minus
import dk.sdu.mmmi.mdsd.math.Mult
import dk.sdu.mmmi.mdsd.math.Plus
import dk.sdu.mmmi.mdsd.math.VarBinding
import dk.sdu.mmmi.mdsd.math.VariableUse
import dk.sdu.mmmi.mdsd.math.Parenthesis
import java.util.HashMap
import java.util.Map
import javax.swing.JOptionPane
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.AbstractGenerator
import org.eclipse.xtext.generator.IFileSystemAccess2
import org.eclipse.xtext.generator.IGeneratorContext
import dk.sdu.mmmi.mdsd.math.MethodCall

/**
 * Generates code from your model files on save.
 * 
 * See https://www.eclipse.org/Xtext/documentation/303_runtime_concepts.html#code-generation
 */
class MathGenerator extends AbstractGenerator {
	
	static Map<String, Integer> variables = new HashMap();

	override void doGenerate(Resource resource, IFileSystemAccess2 fsa, IGeneratorContext context) {
		
		//val math = resource.allContents.filter(MathExp).next
		//val result = math.compute
		//result.displayPanel
		
		for(e : resource.allContents.toIterable.filter(MathExp)) {
			fsa.generateFile(
				"math_expression/"+e.name.toString() + ".java",compile(e)
			)
		}
		
	}
	
	
	private def compile(MathExp mathexp) {
	'''
	package math_expression;
	
	public class «mathexp.name» {
		«FOR exp : mathexp.variables» 
		public int «exp.name»;
		«ENDFOR»
		

		«IF mathexp.externals.size > 0»
		private External external
		
		public «mathexp.name»(External external) {
			this.external = external;
		}
		«ENDIF»		
	
		public void compute() {
			«FOR exp : mathexp.variables» 
			«exp.name» = «exp.expression.computeExpressionString»;
			«ENDFOR»
		}
		
		«IF mathexp.externals.size > 0»	
		interface External {
			«FOR external: mathexp.externals.indexed»
			public int «external.value.name»(«FOR type : external.value.types.indexed SEPARATOR ', '»«type.value» n«type.key»«ENDFOR»)
			«ENDFOR»
		}
		«ENDIF»	
	
	}
	'''
	}
			
	def static dispatch String computeExpressionString(VarBinding binding) {
		var value = binding.expression.computeExpressionString
		return value
	}
	
	def static dispatch String computeExpressionString(MathNumber exp) {
		exp.value.toString
	}

	def static dispatch String computeExpressionString(Plus exp) {
		exp.left.computeExpressionString +' + '+ exp.right.computeExpressionString
	}
	
	def static dispatch String computeExpressionString(Minus exp) {
		exp.left.computeExpressionString + ' - ' + exp.right.computeExpressionString
	}
	
	def static dispatch String computeExpressionString(Mult exp) {
		exp.left.computeExpressionString +' * '+ exp.right.computeExpressionString
	}
	
	def static dispatch String computeExpressionString(Div exp) {
		exp.left.computeExpressionString + ' / '+ exp.right.computeExpressionString
	}
	
	def static dispatch String computeExpressionString(VariableUse exp) {
		if(exp.ref instanceof LetBinding) {
			return (exp.ref as LetBinding).computeExpressionString
		}
		return exp.ref.name
	}
	
	def static dispatch String computeExpressionString(Parenthesis exp) {
		'(' + exp.expreesion.computeExpressionString + ')'
	}
	

	def static dispatch String computeExpressionString(LetBinding exp) {
		exp.body.computeExpressionString
	}
	
	static int counter = 0;
	
	def static dispatch String computeExpressionString(MethodCall binding){
		return binding.signature.name + "("+ binding.args.map[e | e.computeExpressionString].join(', ') +")"
	}

	
	
	

	def static dispatch int computeExpression(VarBinding binding) {
		variables.put(binding.name, binding.expression.computeExpression())
		return variables.get(binding.name)
	}
	
	def static dispatch int computeExpression(MathNumber exp) {
		exp.value
	}

	def static dispatch int computeExpression(Plus exp) {
		exp.left.computeExpression + exp.right.computeExpression
	}
	
	def static dispatch int computeExpression(Minus exp) {
		exp.left.computeExpression - exp.right.computeExpression
	}
	
	def static dispatch int computeExpression(Mult exp) {
		exp.left.computeExpression * exp.right.computeExpression
	}
	
	def static dispatch int computeExpression(Div exp) {
		exp.left.computeExpression / exp.right.computeExpression
	}

	def static dispatch int computeExpression(LetBinding exp) {
		exp.body.computeExpression
	}
	
	def static dispatch int computeExpression(VariableUse exp) {
		exp.ref.computeBinding
	}

	def static dispatch int computeBinding(VarBinding binding){
		if(!variables.containsKey(binding.name))
			binding.computeExpression()			
		variables.get(binding.name)
	}
	
	def static dispatch int computeBinding(LetBinding binding){
		binding.binding.computeExpression
	}
	
	
}
