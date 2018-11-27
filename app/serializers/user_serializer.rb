class UserSerializer < ActiveModel::Serializer
    attributes :id, :email, :name, :role, :created_at

    # belongs_to :employee

    # def role
    #     Role.enum_description[object.role]
    # end

    # def role_id
    #     object.role
    # end
end