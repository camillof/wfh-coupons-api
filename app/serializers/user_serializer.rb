class UserSerializer < ActiveModel::Serializer
    attributes :id, :email, :name, :role, :created_at

    # belongs_to :employee

    # def role
    #     Role.enum_description[object.role]
    # end

    # def role_id
    #     object.role
    # end
    def serializable_hash(adapter_options = nil, options = {}, adapter_instance = self.class.serialization_adapter_instance)
        hash = super
        hash.each { |key, value| hash.delete(key) if value.nil? }
        hash
    end
end