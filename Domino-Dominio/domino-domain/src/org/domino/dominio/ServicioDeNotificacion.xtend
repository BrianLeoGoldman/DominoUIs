package org.domino.dominio

import java.util.Properties
import javax.mail.Authenticator
import javax.mail.Message
import javax.mail.MessagingException
import javax.mail.PasswordAuthentication
import javax.mail.Session
import javax.mail.Transport
import javax.mail.internet.InternetAddress
import javax.mail.internet.MimeMessage
import org.eclipse.xtend.lib.annotations.Accessors
import java.util.Observer
import java.util.Observable

@Accessors
class ServicioDeNotificacion implements Observer {

	UserPasswordAuthentication authentication
	boolean comprobanteDeMailEnviado

	new(String usuario, String contrase�a) {
		authentication = new UserPasswordAuthentication(usuario, contrase�a)
		comprobanteDeMailEnviado = false
		
	}
	
	static ServicioDeNotificacion instance
	
	static def instance() { instance }
	
	static def config(ServicioDeNotificacion sender) { 
		instance = sender
	}

	def sendMail(String para, String asunto, String cuerpo) {

		try {
			comprobanteDeMailEnviado = true
			
			val message = new MimeMessage(createSession)
			message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(para))
			message.subject = asunto
			message.text = cuerpo

			Transport.send(message)
			
		}
		catch (MessagingException exception) {
			comprobanteDeMailEnviado = false

			exception.printStackTrace
			throw exception
			
		}
	}

	private def createSession() {
		
		val props = new Properties => [
			put("mail.smtp.auth", "true")
			put("mail.smtp.starttls.enable", "true")
			put("mail.smtp.host", "smtp.gmail.com")
			put("mail.smtp.port", "587")
		]

		Session.getInstance(props, authentication)
		
	}
	
	override update(Observable o, Object arg) {
		val pedido = o as Pedido
		
		ServicioDeNotificacion.instance.sendMail(pedido.cliente.email,"Test", "Test")
	}
	
}

class UserPasswordAuthentication extends Authenticator {

	val String username
	val String password

	new(String _username, String _password) {
		username = _username
		password = _password
	}

	override protected getPasswordAuthentication() { new PasswordAuthentication(username, password) }

}