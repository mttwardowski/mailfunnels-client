class ResourceApi < Grape::API
  prefix 'api'
  format :json

  def initialize
    super
  end


  get 'email_opened' do
    messageID = params[:messageID]

    emailJob = EmailJob.find(params[:postmark_id])

    node = emailJob.node

    node.clicked = 1
    node.save

  end

  # Apps Resource API
  # -----------------
  resource :apps do
    # Get Routes
    # ----------------
    get do
        App.where(params)
    end

    route_param :id do
      get do
        App.find(params[:id])
      end
    end


    # Post/Put Routes
    # ----------------
    post do
      App.create! params
    end

    put ':id' do
      App.find(params[:id]).update(params)
    end

    put do
      App.update(params)
    end


  end

  # Hooks Resource API
  # ------------------
  resource :hooks do
    # Get Routes
    # ----------------

    get do
        Hook.where(params)
    end

    route_param :id do
      get do
        Hook.find(params[:id])
      end
    end

    # Post/Put Routes
    # ----------------
    post do
      Hook.create! params
    end

    put ':id' do
      Hook.find(params[:id]).update(params)
    end

    put do
      Hook.update(params)
    end


  end


  # Funnels Resource API
  # --------------------
  resource :funnels do
    # Get Routes
    # ----------------
    get do
      Funnel.where(params)
    end


    # GET funnels/:funnel_id
    route_param :funnel_id do
      get do
        Funnel.find(params[:funnel_id])
      end
    end


    # Post/Put Routes
    # ----------------
    post do
      Funnel.create! params
    end

    put ':id' do
      Funnel.find(params[:id]).update(params)
    end

    put do
      Funnel.update(params)
    end


  end


  # Triggers Resource API
  # ---------------------
  resource :triggers do
    # Get Routes
    # ----------------

    get do
      Trigger.where(params)
    end

    route_param :id do
      get do
        Trigger.find(params[:id])
      end
    end


    # Post/Put Routes
    # ----------------

    # creates new Trigger
    # POST /triggers
    post do
      Trigger.create! params
    end

    put ':id' do
      Trigger.find(params[:id]).update(params)
    end

    put do
      Trigger.update(params)
    end

  end

  # Links Resource API
  # ------------------
  resource :links do
    # Get Routes
    # ----------------

    get do
      Link.where(params)
    end

    route_param :id do
      get do
        Link.find(params[:id])
      end
    end


    # Post/Put Routes
    # ----------------
    post do
      Link.create! params
    end

    put ':id' do
      Link.find(params[:id]).update(params)
    end

    put do
      Link.update(params)
    end

  end


  # Nodes Resource API
  # ------------------
  resource :nodes do
    # Get Routes
    # ----------------

    get do
      Node.where(params)
    end

    route_param :id do
      get do
        Node.find(params[:id])
      end
    end


    # Post/Put Routes
    # ----------------
    post do
      Node.create! params
    end

    put ':id' do
      Node.find(params[:id]).update(params)
    end

    put do
      Node.update(params)
    end

  end


  # EmailList Resource API
  # ----------------------
  resource :email_lists do
    # Get Routes
    # ----------------
    get do
        EmailList.where(params)
    end

    route_param :id do
      get do
        EmailList.find(params[:id])
      end
    end

    route_param :id do
      get do
        EmailList.find(params[:id])
      end
    end

    # Post/Put Routes
    # ----------------
    post do
      EmailList.create! params
    end

    put ':id' do
      EmailList.find(params[:id]).update(params)
    end

    put do
      EmailList.update(params)
    end
  end

  # EmailTemplate Resource API
  # --------------------------
  resource :email_templates do
    # Get Routes
    # ----------------
    get do
      EmailTemplate.where(params)
    end

    route_param :id do
      get do
        EmailTemplate.find(params[:id])
      end
      put do
        EmailTemplate.find(params[:id]).update(params)
      end
    end

    # Post/Put Routes
    # ----------------
    post do
      EmailTemplate.create! params
    end

    put ':id' do
      EmailTemplate.find(params[:id]).update(params)
    end

    put do
      EmailTemplate.update(params)
    end

  end

  # CapturedHooks Resource API
  # --------------------------
  resource :captured_hooks do
    # Get Routes
    # ----------------

    get do
        CapturedHook.where(params)
    end

    route_param :id do
      get do
        CapturedHook.find(params[:id])
      end
    end

    # Post/Put Routes
    # ----------------
    post do
      CapturedHook.create! params
    end

    put ':id' do
      CapturedHook.find(params[:id]).update(params)
    end

    put do
      CapturedHook.update(params)
    end


  end

  # Subscriber Resource API
  # ------------------------
  resource :subscribers do
    # Get Routes
    # ----------------
    get do
      Subscriber.where(params)
    end

    route_param :id do
      get do
        Subscriber.find(params[:id])
      end
    end

    
    route_param :id do
      get do
        Subscriber.find(params[:id])
      end
    end

    # Post/Put Routes
    # ----------------
    post do
      Subscriber.create! params
    end

    put ':id' do
      Subscriber.find(params[:id]).update(params)
    end

    put do
      Subscriber.update(params)
    end
  end

  # EmailListSubscriber Resource API
  # ------------------------
  resource :email_list_subscribers do
    # Get Routes
    # ----------------
    get do
      EmailListSubscriber.where(params)
    end

    route_param :id do
      get do
        EmailListSubscriber.find(params[:id])
      end
    end

    # Post/Put Routes
    # ----------------
    post do
      EmailListSubscriber.create! params
    end

    put ':id' do
      EmailListSubscriber.find(params[:id]).update(params)
    end

    put do
      EmailListSubscriber.update(params)
    end
  end

  # EmailJobResource API
  # ------------------------
  resource :email_jobs do
    # Get Routes
    # ----------------
    get do
      EmailJob.where(params)
    end

    route_param :id do
      get do
        EmailJob.find(params[:id])
      end
    end

    # Post/Put Routes
    # ----------------
    post do
      emailJob = EmailJob.create params
      node = Node.find(emailJob.node_id)
      if node.delay_unit == 1
        SendEmailJob.set(wait: node.delay_time.minutes).perform_later(emailJob.id)
      elsif node.delay_unit == 2
        SendEmailJob.set(wait: node.delay_time.hours).perform_later(emailJob.id)
      end

      puts "---Email Job Created---"
    end

    put ':id' do
      EmailJob.find(params[:id]).update(params)
    end

    put do
      EmailJob.update(params)
    end
  end

  # BatchEmailJobResource API
  # ------------------------
  resource :batch_email_jobs do
    # Get Routes
    # ----------------
    get do
      BatchEmailJob.where(params)
    end

    route_param :id do
      get do
        BatchEmailJob.find(params[:id])
      end
    end

    # Post/Put Routes
    # ----------------
    post do
      batchEmailJob = BatchEmailJob.create params
      emailList = EmailList.where(id: batchEmailJob.email_list_id)
      emailList.email_list_subscribers.each do |listSubscriber|
        emailJob = EmailJob.create(subscriber_id: listSubscriber.subscriber.id,
                        email_template_id: batchEmailJob.email_template_id,
                        app_id: batchEmailJob.app_id,
                        batch_email_job_id: batchEmailJob.id,
                        sent:0,
                        executed:false,
                        clicked:0)

        BatchEmailJob.perform_later(emailJob)
        puts "---created batch email job---"
      end

      puts "---All batch jobs created---"
    end

    put ':id' do
      BatchEmailJob.find(params[:id]).update(params)
    end

    put do
      BatchEmailJob.update(params)
    end
  end


end