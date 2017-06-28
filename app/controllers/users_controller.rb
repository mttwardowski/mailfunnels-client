class UsersController < ActionController::Base

  # PAGE RENDER FUNCTION
  # --------------------
  # Renders the Login Page for MailFunnels
  #
  def login_page

  end


  # PAGE RENDER FUNCTION
  # --------------------
  # Renders the account disabled page
  #
  def access_denied

  end

  # PAGE RENDER FUNCTION
  # --------------------
  # Renders the server error page
  #
  def server_error

  end


  # POST ROUTE
  # ----------
  # Creates a new App Instance
  # Used with infusionsoft to create new account
  # upon app order form submit
  #
  # PARAMETERS
  # ----------
  # client_id: Infusionsoft Client ID
  # email: Email Address of the User
  # password: Password of the User
  # first_name: First Name of the User
  # last_name: Last Name of the User
  #
  def mf_api_user_create

    # Look for
    current_users = User.where(email: params[:email_address])

    if current_users.empty?
      response = {
          success: false,
          message: 'User with email already exists'
      }

      render json: response
    end

    user = User.new

    user.clientid = params[:client_id]
    user.email = params[:email]
    user.password = params[:password]
    user.first_name = params[:first_name]
    user.last_name = params[:last_name]

    user.save

    # Return Success Response
    response = {
        success: true,
        user_id: user.id,
        message: 'User Created'
    }

    render json: response


  end


  # USED WITH AJAX
  # --------------
  # Authenticates the user and redirects to shopify auth
  #
  # PARAMETERS
  # ----------
  # mf_auth_username: Username of the user
  # mf_auth_password: Password of the user
  #
  def ajax_mf_user_auth

    # Get User Information from Infusionsoft
    contact = Infusionsoft.contact_find_by_email(params[:mf_auth_username], [:ID, :Password])

    if contact.first['Password'] === params[:mf_auth_password]

      user = User.where(clientid: contact.first['ID']).first

      unless user
        # Return Error Response
        response = {
            success: false,
            message: 'Authentication Failed'
        }

        render json: response
      end

      # Look for App for the User
      app = App.where(user_id: user.id).first

      logger.info app


      if app

        # Return Json Response with shopify domain
        response = {
            success: true,
            type: 2,
            url: app.name,
            message: 'Authentication Passed'
        }

        render json: response

      else

        response = {
            success: true,
            type: 1,
            user_id: user.id,
            url: 'none',
            message: 'User has not configured Shopify Domain yet.'
        }
        render json: response
      end



    else

      # Return Error Response
      response = {
          success: false,
          message: 'Authentication Failed'
      }

      render json: response

    end
  end


  # USED WITH AJAX
  # --------------
  # Creates a new App for the User
  #
  # PARAMETERS
  # ----------
  # user_id: ID of the User to create App For
  # domain: Shopify Domain to install the App with
  #
  def ajax_mf_app_create

    domain = params[:domain] + ".myshopify.com"

    digest = OpenSSL::Digest.new('sha256')
    token = Base64.encode64(OpenSSL::HMAC.digest(digest, ENV['SECRET_KEY_BASE'], params[:domain])).strip
    app = App.create(user_id: params[:user_id], name: domain, auth_token: token)

    response = {
        success: true,
        url: app.name,
        message: 'App Created!'
    }

    render json: response

  end


  # USED WITH AJAX
  # --------------
  # Updates the Users tags upon a failed payment
  #
  # PARAMETERS
  # ----------
  # client_id: ID of the Infusionsoft contact
  #
  def mf_api_failed_payment

    # Get User From DB with client_id
    user = User.where(clientid: params[client_id]).first

    # If user not found, return error response
    if user.empty?
      response = {
          success: false,
          message: 'User with ClientID not found'
      }

      render json: response
    end

    # Get the Infusionsoft contact info
    contact = Infusionsoft.data_load('Contact', user.clientid, [:Groups])

    # Update User Tags
    user.put('', {
        :client_tags => contact['Groups']
    })


    response = {
        success: true,
        message: 'User Tags Updated'
    }

    render json: response


  end


end
