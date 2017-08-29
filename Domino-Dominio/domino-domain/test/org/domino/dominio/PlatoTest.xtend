package org.domino.dominio

import org.junit.Test
import static org.junit.Assert.*
import static org.mockito.Mockito.*

class PlatoTest {
	
	Pizza pizza = mock(Pizza)
	String tama�o = "Grande"
	Ingrediente ingred1 = mock(Ingrediente)
	Ingrediente ingred2 = mock(Ingrediente)
	Plato plato1 = new Plato(pizza, tama�o)
	
	@Test
	def testUnPlatoTieneUnaPizzaYUnTama�o() {
		when(pizza.nombre).thenReturn("Napolitana")
		assertEquals("Napolitana", plato1.pizza.nombre)
		assertEquals("Grande", plato1.tama�o)
	}
	
	@Test
	def testUnPlatoPuedeTenerIngredientesExtras() {
		plato1.agregarIngredienteExtra(ingred1)
		plato1.agregarIngredienteExtra(ingred2)
		assertEquals(2, plato1.ingredientes.size)
		assertTrue(plato1.ingredientes.contains(ingred1))
		assertTrue(plato1.ingredientes.contains(ingred2))
	
	}
}