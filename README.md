AC215 Milestone3
==============================

Project Organization
------------
    .
    └── ac215_healthychickensaladeers
        ├── LICENSE
        ├── README.md
        ├── docker-compose.yml
        ├── docs
        │   ├── docker-gcsfuse.md
        │   ├── experiment-bert.md
        │   ├── gcp-cli-instructions-macos.md
        │   ├── gcp-scraper-commands.md
        │   ├── gcp-setup-instructions.md
        │   └── gcs-bucket-instructions.md
        ├── img
        │   ├── <list_of_many_images_used_in_markdown>
        ├── notebooks
        │   ├── BERT_fine-tune_financials
        │   │   ├── 50Agree.ipynb
        │   │   ├── 66Agree.ipynb
        │   │   ├── 75Agree.ipynb
        │   │   ├── AllAgree.ipynb
        │   │   └── finetune_bert_py_in_colab.ipynb
        │   ├── add_data_to_weaviate_new.ipynb
        │   ├── add_data_to_weaviate_old.ipynb
        │   ├── financial_data
        │   │   ├── Sentences_50Agree.txt
        │   │   ├── Sentences_66Agree.txt
        │   │   ├── Sentences_75Agree.txt
        │   │   └── Sentences_AllAgree.txt
        │   ├── sample_data
        │   │   └── www.chooch.com_2023-10-03T15-30-00.csv
        │   ├── scraping_notebook.ipynb
        │   └── sitemap.csv
        ├── reports
        │   └── milestone2.md
        └── src
            ├── bert_financial
            │   ├── Dockerfile
            │   ├── Pipfile
            │   ├── Pipfile.lock
            │   ├── entrypoint.sh
            │   ├── finetune_bert.py
            │   └── gcsbucket
            ├── llama_index
            │   ├── Dockerfile
            │   ├── Pipfile
            │   ├── Pipfile.lock
            │   ├── build_query.py
            │   ├── data
            │   │   └── paul_graham_essay.txt
            │   ├── entrypoint.sh
            │   └── gcsbucket
            ├── prompts
            │   └── prompts.py
            ├── scraper
            │   ├── Dockerfile
            │   ├── Pipfile
            │   ├── Pipfile.lock
            │   ├── chromedriver
            │   ├── log
            │   ├── rag-detective-2ed9f2d52fde.json
            │   ├── scraper.py
            │   ├── scraperlib.py
            │   ├── scraping_notebook.ipynb
            │   ├── scraping_notebook_milestone3.ipynb
            │   └── sitemap.csv
            └── vector_store
                ├── schema.json
                ├── schema_old.json
                ├── weaviate.schema.md
                └── weaviate.schema.old.md


--------
# AC215 - Milestone3 - RAG Detective

**Team Members**
Ian Kelk, Mandy Wong, Alyssa Lutservitz, Nitesh Kumar, Bailey Bailey

**Group Name**
Healthy Chicken Saladeers

**Project**
To develop an application that uses Retrieval Augmented Generation (RAG) with an LLM to create a chatbot that can answer specific questions about a company through the complete knowledge of all the information available publicly on their website in a manner that’s more specific and insightful than using a search engine.

### Fine-tuning BERT with Financial data for sentiment analysis

In order to fulfill the model training and experimentation aspect of this project, we decided to fine-tune the 110M parameter model BERT, which stands for `Bidirectional Encoder Representations from Transformers`, a machine learning model used for natural language processing tasks.

Rather than our original idea of hosting our own embedding model, which has become impractical due to the lack of a GPU and BERT's short 512 token context, we can use this model to perform sentiment analysis of any financial information returned by the LLM. We can proceed with it through the following milestones as well, as we used TensorFlow to train it and can proceed with the later goals of distillation, quantization, or compression.

One of the challenges faced in financial sentiment analysis is the limited availability of quality annotated training data. We used the `financial_phrasebank` dataset, which draws attention to the potential influences of annotator consensus on sentiment predictions. A curated collection of 4846 sentences from English financial news, the dataset is categorized into three sentiment classes: Neutral, Positive, and Negative. Notably, it provides varying configurations based on degrees of annotator agreement, spanning from 50% to a complete consensus.

The annotations, derived from a diverse group of 16 financial professionals and students, revealed an interesting trend: as the degree of annotator consensus increased, so did the model's performance. However, this observation might carry an inherent bias, suggesting that sentences with clearer sentiments—due to higher annotator agreement—might be inherently easier to predict.

We weren't able to get multiple GPUs through Google Vertex, however I was able to use an A100 GPU through Google Colab. This GPU took what was going to be a multiple hour training on my Mac CPU and was able to run it in under 30 minutes. I've both run the `finetune_bert.py` file in both the notebook format for greater readability, as well as using a simple `!python finetune_bert.py` as the first line of a notebook.

Links to the notebooks, which are identical but used the 4 different datasets depending on annotator consensus:

* [50% annotator consensus](https://github.com/healthy-chicken-saladeers/ac215_healthychickensaladeers/blob/milestone3/notebooks/BERT_fine-tune_financials/50Agree.ipynb)
* [66% annotator consensus](https://github.com/healthy-chicken-saladeers/ac215_healthychickensaladeers/blob/milestone3/notebooks/BERT_fine-tune_financials/66Agree.ipynb)
* [75% annotator consensus](https://github.com/healthy-chicken-saladeers/ac215_healthychickensaladeers/blob/milestone3/notebooks/BERT_fine-tune_financials/75Agree.ipynb)
* [100% annotator consensus](https://github.com/healthy-chicken-saladeers/ac215_healthychickensaladeers/blob/milestone3/notebooks/BERT_fine-tune_financials/AllAgree.ipynb)

We also ran this with just our `finetune_bert.py` file. We still had to install Hugging Face `transformers` and `wandb` because these are handled by `Pipfile`, and there are no plots displayed since in our container the plots are saved directly to disk without being shown.

* [50% annotator consensus in `finetune_bert.py` run on Colab](https://github.com/healthy-chicken-saladeers/ac215_healthychickensaladeers/blob/milestone3/notebooks/BERT_fine-tune_financials/finetune_bert_py_in_colab.ipynb)

#### For in-depth information on our training experiment, including discussion of the data, training methodology, conclusions, and interactive plots where you can hover your mouse for further detail, [please see our Weights & Biases report](https://wandb.ai/iankelk/bert-sentiment/reports/BERT-Fine-tuning-on-Financial-Data--Vmlldzo1NTg3MTg3)

#### Note: The Weights & Biases report site is not always reliable. For a static version [see here.](./docs/experiment-bert.md)

A static version of the most useful plots is here, showing the results for the 4 datasets representing 4 levels of annotator consensus:

![](./img/experiment-results.jpg)

### More docs

*NEW:* Detailed instructions on how to install the Google Cloud CLI on your Mac while working on a project like this. It's a much better experience than using the web browser or plain SSH:
* [docs/gcp-cli-instructions-macos.md](./docs/gcp-cli-instructions-macos.md)

*NEW:* Step-by-step instructions with screenshots on how to set up a Google Cloud Storage bucket:
* [docs/gcs-bucket-instructions.md](./docs/gcs-bucket-instructions.md)

*UPDATED:* To run the installation from scratch on a new Google Cloud instance, full instructions are located in:
* [docs/gcp-setup-instructions.md](./docs/gcp-setup-instructions.md)

*UPDATED:* Granular instructions on how to run the `scraper` container alone are located in:
* [docs/gcp-scraper-commands.md](./docs/gcp-scraper-commands.md)

# Web Scraper

This Python project provides code for web scraping, which extracts data from webpages for data analysis. The main codebase consists of two parts:

1. `main()` function that coordinates the data extraction process.
2. `scraperlib` library provides necessary tools to scrape website data based on a sitemap.

The sense of the project is to crawl over each URL provided in a CSV file called `sitemap.csv` and extract the text from found webpages. Extracted text from each webpage is saved into another CSV file, which can be used for data analysis purposes later.

## Working Principle

-   `main()` function reads the `sitemap.csv` containing URLs of different sitemaps to be scraped.
-   It then loops through each sitemap, calling the `scrape_sitemap()` function from the `scraperlib` library to extract links from the sitemap.
-   `scrape_website()` function then scrapes data from the URLs extracted in the above step and returns a dataframe containing scraped data along with a log dataframe.
-   Scraped data is then saved into a CSV using the `save_file()` function.

The library also ensures scraping accuracy by switching to selenium in case of small amounts of content or unsuccessful requests to pages. Errors during the scraping process are also recorded in a separate log dataframe.

## scraperlib Library

This library provides several functions that allow the main program to extract data from a webpage:

-   `set_chrome_options()` function provides browser options for Selenium web driver with headless mode(meaning without graphical user interface) on.
-   `scrape_sitemap(url)` function returns links present in the sitemap. Extracts 'loc' tags using BeautifulSoup.
-   `scrape_website(all_links, options)` function extracts text data from the webpages in given links. Uses BeautifulSoup to extract data and Selenium if requests is unsuccessful or the content is too small.
-   `save_file(df, filename)` function saves data into a CSV file. It can also store data to Google Cloud Storage if running in a GCP environment.
-   `headers` variable ensures that webpages treat our web scraper as a browser for compatibility.

![](./img/bucket.jpg)

The scraper's output from each webpage is a CSV file that contains the text data extracted from the webpage. The data is stored in a pandas DataFrame with two columns - 'key' and 'text'. The 'key' corresponds to the webpage's URL, and the 'text' contains the extracted textual data from the webpage. 

In the case of any error during the scraping process, a log DataFrame is generated with 'key' and 'error'. Here, 'key' is the webpage's URL, and 'error' records the specific error encountered. This error log is saved as a CSV in the application's log/ directory. These logs help trace back any exceptions or errors encountered during the scraping process.  

When running in a Google Cloud Platform (GCP) environment, if the scraper has appropriate access right, the CSVs files (both data and error logs) are directly stored in the Google Cloud Storage bucket instead of the local filesystem. The bucket is named `"ac215_scraper_bucket"` as per the script.

When the scraper successfully stores a CSV file into the `"ac215_scraper_bucket"`, it prints a message signifying the successful operation and provides the path to the saved CSV in the bucket.

Because it only needs to write individual files into the bucket, the scraper uses the `google.cloud.storage` library, unlike the `llama_index` and `finetune_bert` containers which use `gcsfuse` to mount the bucket locally.

#### Some experimentation with scraping

* **[scraping_notebook_milestone3.ipynb](https://github.com/healthy-chicken-saladeers/ac215_healthychickensaladeers/blob/milestone3/notebooks/scraping_notebook_milestone3.ipynb)** is an updated notebook where we experimented with Selenium for web scraping.

## Files in Scraper

* **chromedriver** is a separate component provided by the Google that acts as a server to interact with the Chrome browser. It is an essential tool for controlling a web browser through programs and performing browser automation. It is functional for all browsers built on Chrome and is a vital component in tools like Selenium for controlling Chrome during automated scraping, which we use when a page is rendered with JavaScript.
* **log** is a folder which contains the logs generated by the scraping process.
* **rag-detective-2ed9f2d52fde.json** a Google Cloud Service Account key
* **[sitemap.csv](https://github.com/healthy-chicken-saladeers/ac215_healthychickensaladeers/blob/milestone3/src/scraper/sitemap.csv)** is the list of sites we have scraped:
    - [bland.ai](https://bland.ai/sitemap.xml)
    - [cohere.com](https://cohere.com/sitemap.xml)
    - [ai21.com](https://ai21.com/sitemap.xml)
    - [descript.com](https://descript.com/sitemap.xml)
    - [weaviate.io](https://weaviate.io/sitemap.xml)
    - [assemblyai.com](https://assemblyai.com/sitemap.xml)
    - [anthropic.com](https://anthropic.com/sitemap.xml)
    - [inflection.ai](https://inflection.ai/sitemap.xml)
    - [h2o.ai](https://h2o.ai/sitemap.xml)
    - [harver.com](https://harver.com/sitemap_index.xml)
    - [dataminr.com](https://dataminr.com/sitemap.xml)
    - [shield.ai](https://shield.ai/sitemap_index.xml)
    - [kymeratx.com](https://kymeratx.com/sitemap.xml)
    - [arvinas.com](https://arvinas.com/sitemap.xml)
    - [ardelyx.com](https://ardelyx.com/sitemap.xml)
    - [monterosatx.com](https://monterosatx.com/sitemap.xml)
    - [trianabio.com](https://trianabio.com/sitemap.xml)
    - [tangotx.com](https://tangotx.com/sitemap.xml)
    - [vertex.com](https://vertex.com/sitemap.xml)
    - [vervetx.com](https://vervetx.com/sitemap.xml)
    - [novonordisk.com](https://novonordisk.com/sitemap.xml)
    - [shionogi.com](https://shionogi.com/us/en/sitemap.xml)
    - [alexion.com](https://alexion.com/sitemap.xml)
    - [relaytx.com](https://relaytx.com/sitemap.xml)
    - [neumoratx.com](https://neumoratx.com/sitemap.xml)
    - [verily.com](https://verily.com/sitemap.xml)
    - [kojintx.com](https://kojintx.com/sitemap.xml)

# Weaviate Vector Store Container

*NEW* Our Weaviate schema and explanation can be read [here](https://github.com/healthy-chicken-saladeers/ac215_healthychickensaladeers/blob/milestone3/src/vector_store/weaviate.schema.md) and in JSON format [here](https://github.com/healthy-chicken-saladeers/ac215_healthychickensaladeers/blob/milestone3/src/vector_store/schema.json)

*NEW* Just for fun, and because it's part of the building process, our original hierarchical schema can be read [here](https://github.com/healthy-chicken-saladeers/ac215_healthychickensaladeers/blob/milestone3/src/vector_store/weaviate.schema.old.md) and in JSON format [here.](https://github.com/healthy-chicken-saladeers/ac215_healthychickensaladeers/blob/milestone3/src/vector_store/schema_old.json) We had to change to a flat structure due to limitations on deep hierarchical querying of Weaviate.

Weaviate is an open-source knowledge graph program that utilizes GraphQL and RESTful APIs. It’s designed to organize large amounts of data in a manner that makes the data interconnected and contextual, allowing users to perform semantic searches and analyses. It can automatically classify and interpret data through machine learning models, facilitating more intelligent and informed data retrievals and insights. It is scalable and can be used for a variety of applications, such as data analysis and information storage and retrieval.

Weaviate can be queried through either a semantic (vector) search, a lexical (scalar) search, or a combination of both. A vector search enables the execution of searches based on similarity, while scalar searches facilitate filtering through exact matches. This is important, as it will allow us to query for specific website scrapes and dates, as well as match the embeddings to find relevant data.

In our current cloud instance with everything installed, the command to start everything up is just:

* `docker-compose up -d` to start up the containers
* `docker-compose down` to stop them.

# LlamaIndex

*NEW* A detailed step-by-step demonstration and explanation of how to accomplish RAG with Weaviate is shown in [this notebook.](https://github.com/healthy-chicken-saladeers/ac215_healthychickensaladeers/blob/milestone3/notebooks/add_data_to_weaviate_new.ipynb) Since we had originally started with the more complex (and eventually abandoned) hierarchical schema which we tried to use [here](https://github.com/healthy-chicken-saladeers/ac215_healthychickensaladeers/blob/milestone3/notebooks/add_data_to_weaviate_old.ipynb), we haven't needed the LlamaIndex framework yet, however regardless of if we use it or not, we will still require this container for the application.

#### Note: The data used in the notebook is the sample data `
www.chooch.com_2023-10-03T15-30-00.csv`. In production, the RAG implementation will pull from a GCS bucket, and `gcsfuse` is already implemented: when you launch the container, it logs you in automatically.

#### A full explanation of this process and how it works is detailed [here.](./docs/docker-gcsfuse.md)

Retrieval Augmented Generation (RAG) serves as a framework to enhance Language and Learning Models (LLM) using tailored data. This approach typically involves two primary phases:

1. **Indexing Phase**: This is the initial stage where a knowledge base is developed and organized for future references.

2. **Querying Phase**: In this phase, pertinent information is extracted from the prepared knowledge base to aid the LLM in formulating responses to inquiries.

### Indexing Stage

In the initial indexing stage, text data must be first collected as documents and metadata. In this implementation, this is performed by the scraping of website. This data must be then split into "nodes", which is a represents a "chunk" or part of the data containing a certain portion of information. Nodes must are then indexed via an embedding model, where we plan on using OpenAI's `Ada v2` embedding model. The embeddings and metadata together create a rich representation to aid in retrieval.

![](img/indexing.png)

### Querying Stage
In this stage, the RAG pipeline extracts the most pertinent context based on a user’s query and forwards it, along with the query, to the LLM to generate a response. This procedure equips the LLM with current knowledge that wasn’t included in its original training data. This also reduces the likelihood of hallucinations, a problem for LLMs when they invent answers for data they were insufficiently trained with. The pivotal challenges in this phase revolve around the retrieval, coordination, and analysis across one or several knowledge bases.

![](img/querying.png)

LlamaIndex is a data framework to ingest, structure, and access private or domain-specific data. We plan on using it to chunk our text data and combine it with the metadata to create nodes to insert into the Weaviate vector store. We plan on using its functions as follows:

* **Data connector** to ingest the nodes into Weaviate
* **Data index** using Weaviate to store the embeddings and 
* **Query engine** to retreive the knowledge-augmented output
* **Application integrations** to work with Docker and likely Flask.

At present, LlamaIndex is set up to run a short "build and index" query using Paul Graham’s essay, [“What I Worked On”](http://paulgraham.com/worked.html). As we build the application, this will be changed to query the Weaviate store and output to the OpenAI API.

# Note

* Data for the RAG system is stored in the GCS bucket. The only data that is stored in GCS is a [single sample file](https://github.com/healthy-chicken-saladeers/ac215_healthychickensaladeers/blob/milestone3/notebooks/sample_data/www.chooch.com_2023-10-03T15-30-00.csv) for the RAG demonstration, and the [four CSV files](https://github.com/healthy-chicken-saladeers/ac215_healthychickensaladeers/tree/milestone3/notebooks/financial_data) that comprise the 2MB of data for the BERT fine-tuning are inside the `notebooks` folder to allow it to be run locally. They will be moved to the bucket when we get further with the BERT model.

* We do not have any `requirements.txt` present since the dependencies are handled by the Dockerfiles.

* Currently, both Weaviate and LlamaIndex have access to the OpenAI API. There are two models that need to be used; the `Ada v2` embedding model and `GPT-3.5`, so depending on how the work is distributed for the data ingestion and the retrieval, one or both of Weaviate or LlamaIndex may use the API.

# Additional Files

### *UPDATED:* `docker-compose.yml`

- **version**: Specifies the Docker Compose file version.
  
### Services:

1. **weaviate**:
    - **command**: The command and its arguments to start the container.
    - **image**: Uses the image `semitechnologies/weaviate:1.21.3`.
    - **ports**: Maps port 8080 of the host to port 8080 of the container.
    - **volumes**: Mounts a named volume `weaviate_data` at `/var/lib/weaviate` in the container.
    - **restart**: If the container fails, it won't be restarted.
    - **environment**: Sets various environment variables, such as OpenAI API key, default limits, persistence path, modules, etc.

2. **scraper**:
    - **build**: Builds the image using the Dockerfile found in `./src/scraper`.
    - **container_name**: Names the container `scraper`.
    - **user**: Sets the user as `appuser`.
    - **command**: Runs `scraper.py` using Python.
    - **volumes**: Mounts the local `./src/scraper/scraper_data` directory to `/app/data` in the container.

3. **llama_index**:
    - **build**: Builds the image using the Dockerfile found in `./src/llama_index`.
    - **container_name**: Names the container `llama_index`.
    - **user**: Sets the user as `appuser`.
    - **command**: Keeps the container running indefinitely using the `tail -f /dev/null` trick.
    - **volumes**: Mounts the local `./src/llama_index` directory to `/app` in the container.
    - **environment**: Sets the OpenAI API key. This uses the same key as weaviate if needed.
    - **privileged**: Runs the container in privileged mode.

4. **finetune_bert**:
    - **build**: Builds the image using the Dockerfile found in `./src/bert_financial`.
    - **container_name**: Names the container `finetune_bert`.
    - **user**: Sets the user as `appuser`.
    - **command**: Keeps the container running indefinitely using the `tail -f /dev/null` trick.
    - **volumes**: Mounts the local `./src/bert_financial` directory to `/app` in the container.
    - **privileged**: Runs the container in privileged mode.

### Volumes:

- **weaviate_data**: A named volume to store Weaviate data.
- **scraper_data**: A named volume for the scraper service. Not attached to a specific path in the `docker-compose.yml`, but might be used elsewhere or intended for future use.

As mentioned previously, to run the defined services, navigate to the root project directory containing the `docker-compose.yml` file and run the following command in the terminal:

```sh
docker-compose up
```

### `gcp-scraper-commands.md` and `gcp-setup-instructions.md`

* Additional documentation files in markdown format on starting up the project from a brand new GCP instance and to control the Docker containers individually if so desired

### `img` folder

* Image assets for display in this and the above markdown files.

### `notebooks`

* This folder contains the code and output of our scraper in `scraping_notebook.ipynb`. The `sitemap.csv` is a list of sitemaps to scrape, currently set to only [apple.com](https://apple.com). It also contains the results of the scraping, `scraped_data1.csv`.

### `src`

* Contains all the Python code and Dockerfiles to build the project. It also contains the data `paul_graham_essay.txt` which is used as test data for LlamaIndex.
