class CreateTitulos < ActiveRecord::Migration[6.1]
  def change
    create_table :titulos do |t|
      t.text :cnpj_cedente
      t.text :cnpj_sacado
      t.text :numero_titulo
      t.float :valor
      t.date :data_vencimento
      t.date :data_importacao
      t.integer :status
    end
  end
end
