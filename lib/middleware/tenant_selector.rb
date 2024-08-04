# lib/middleware/tenant_selector.rb
class TenantSelector
  def initialize(app)
    @app = app
  end

  def call(env)
    server_name = ENV['SERVER_NAME']
    puts "********** TenantSelector server_name: #{server_name}" # Adiciona uma linha de debug para verificar o env

    if tenant = Tenant.tenant_from_env(server_name)
      tenant.switch do # aqui vem a magia, a requisição vai continuar dentro do tenant, não vai ser possível acessar o banco de dados de outros clientes
        @app.call(env)
      end
    else
      [404, { 'Content-Type' => 'text/html' }, ['Not Found']]
    end
  end
end