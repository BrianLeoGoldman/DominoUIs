package org.domino.dominio

import java.text.SimpleDateFormat
import java.util.Date
import org.junit.Test

import static org.junit.Assert.*
import static org.mockito.Mockito.*

class PedidosTest {

	Cliente cliente = mock(Cliente)
	Cliente cl1 = new Cliente("Honer", "henborda", "123456", "ranidalf@gmail.com" ,"Calle 28")
	SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
	Date fecha = sdf.parse("2015-05-26");
	String aclaracion = "Esto es una aclaracion"
	FormaDeEnvio envio1 = new RetiraPorElLocal
	FormaDeEnvio envio2 = new Delivery("Calle 777")
  	Pedido pedido1 = new Pedido(cl1, fecha, aclaracion, envio1)
	Pedido pedido2 = new Pedido(cl1, fecha, aclaracion, envio2)
	Menu menu = mock(Menu)
	ServicioDeNotificacion servicio = mock(ServicioDeNotificacion)
	DominoPizza dominoPizza = new DominoPizza(menu, servicio)

	@Test
	def testUnPedidoTieneUnClienteUnaFechaUnaAclaracion() {
		when(cliente.nombre).thenReturn("Honer")
		assertEquals(cliente.nombre, pedido1.cliente.nombre)
		assertEquals(fecha, pedido1.fecha)
		assertEquals(aclaracion, pedido1.aclaracion)
	}

	@Test
	def testUnPedidoTieneUnEstadoInicialDePreparado() {
		assertTrue(pedido1.estado instanceof Preparando)
	}

	@Test
	def testUnPedidoPuedeCambiarDeEstadoCuandoSeRetiraPorElLocal() {
		pedido1.siguienteEstado()
		pedido1.siguienteEstado()
		assertTrue(pedido1.estado instanceof Entregado)
	}

	@Test
	def testUnPedidoPuedeCambiarDeEstadoCuandoSePideDelivery() {

		pedido2.siguienteEstado

		assertTrue(pedido2.estado instanceof ListoParaEnviar)
	}

	@Test
	def testAUnPedidoSeLePuedeAgregarPlatos() {
		var dummyPlato = mock(Plato)
		pedido1.agregarPlato(dummyPlato)

		assertTrue(pedido1.platos.contains(dummyPlato))
	}

	@Test
	def unPedidoParaRetirarEnElLocalTieneComoMontoFinalLaSumaDelMontoDeSusPlatos() {
		var plato1 = mock(Plato)
		when(plato1.montoTotal()).thenReturn(10.0)
		var plato2 = mock(Plato)
		when(plato2.montoTotal()).thenReturn(25.0)

		pedido1.agregarPlato(plato1)
		pedido1.agregarPlato(plato2)

		assertEquals(35, pedido1.montoTotal())
	}

	@Test
	def unPedidoParaDeliveryTieneComoMontoFinalLaSumaDelMontoDeSusPlatosMasUnRecargo() {
		var plato1 = mock(Plato)
		when(plato1.montoTotal()).thenReturn(10.0)
		var plato2 = mock(Plato)
		when(plato2.montoTotal()).thenReturn(25.0)

		pedido2.agregarPlato(plato1)
		pedido2.agregarPlato(plato2)
		
		assertEquals(50, pedido2.montoTotal())
	}
	
	@Test
	def unPedidoEnViajeNotificaAlClienteQueSuPedidoEstaEnCamino(){
		pedido2.siguienteEstado
		pedido2.siguienteEstado
		
		assertTrue(pedido2.estado instanceof EnViaje)
	}

	@Test
	def testUnPedidoPuedeSerCanceladoEnCualquierEtapa() {
		pedido1.cancelar
		assertTrue(pedido1.estado instanceof Cancelado)

		pedido2.siguienteEstado
		pedido2.siguienteEstado
		pedido2.cancelar
		assertTrue(pedido2.estado instanceof Cancelado)
	}
	
	@Test
	def testUnPedidoPuedeVolverASuEstadoAnterior() {
		pedido1.siguienteEstado
		assertTrue(pedido1.estado instanceof ListoParaRetirar)
		pedido1.anteriorEstado
		assertTrue(pedido1.estado instanceof Preparando)

		pedido2.siguienteEstado
		pedido2.siguienteEstado
		assertTrue(pedido2.estado instanceof EnViaje)
		pedido2.anteriorEstado
		assertTrue(pedido2.estado instanceof ListoParaEnviar)
		
	}
	
	@Test
	def testUnPedidoPuedeDecirCuantoTiempoTardoEnEntregarse() {
		
		dominoPizza.realizarPedido(pedido1)
		pedido1.siguienteEstado
		pedido1.siguienteEstado
		
		assertEquals(0, pedido1.tiempoDelPedido())
	}

}