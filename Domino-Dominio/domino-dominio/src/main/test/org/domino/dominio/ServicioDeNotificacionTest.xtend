package org.domino.dominio

import org.junit.Test
import org.domino.dominio.ServicioDeNotificacion
import static org.junit.Assert.*
import org.junit.Ignore

class ServicioDeNotificacionTest {

	ServicioDeNotificacionMock servicioDeNotificacionMock
	
	ServicioDeNotificacion servicioDeNotificacion
	
	@Test
	def testUnServicioDeNotificacionEnviaUnMailDesdeUnCorreoValidoMock()	{

		servicioDeNotificacionMock = new ServicioDeNotificacionMock("ciu.dominos.pizza@gmail.com", "interfaces2017")
		servicioDeNotificacionMock.sendMail("ranidalf@gmail.com","Prueba!","Prueba de envio de mail!")
		
		assertTrue(servicioDeNotificacionMock.comprobanteDeMailEnviado)
	}
	@Ignore
	@Test
	def testUnServicioDeNotificacionEnviaUnMailDesdeUnCorreoValido() {
		servicioDeNotificacion = new ServicioDeNotificacion("ciu.dominos.pizza@gmail.com", "interfaces2017")
		servicioDeNotificacion.sendMail("ranidalf@gmail.com","Prueba!","Prueba de envio de mail!")
	}
}
class ServicioDeNotificacionMock extends ServicioDeNotificacion {
	new(String usuario, String contrasenia) {
		super(usuario, contrasenia)
	}
	
	override sendMail(String para, String asunto, String cuerpo) { 
		comprobanteDeMailEnviado = true
	}
	
}