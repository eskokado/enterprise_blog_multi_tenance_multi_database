class Tenant < TenancyRecord
  def self.tenant_from_env(server_name)
    puts "SERVER_NAME: #{server_name}" # Adiciona uma linha de debug para verificar o valor de SERVER_NAME

    Tenant.find_by(name: server_name) # Aqui recomendo colocar um cache em memória por questões de desempenho
  end

  def switch
    ActiveRecord::Base.connected_to(role: :writing, shard: name.to_sym) do
      yield
    end
  end
end