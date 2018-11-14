# base.rb是所有api入口

module API
  class Base < Grape::API
    mount V1::Blogs #把api/blogs.rb mount進來，Grape支援不同api class互相掛載

    add_swagger_documentation(
      info: {
        title: 'GrapeRailsTemplate API Documentation',
        contact_email: 'service@eggman.tv'
      },
      mount_path: '/doc/swagger',
      doc_version: '0.1.0'
    )
  end
end
