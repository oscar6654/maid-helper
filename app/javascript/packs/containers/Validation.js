import React,{ Component } from 'react'
import {Button, Icon, Modal, Col, Preloader, Row} from 'react-materialize'
import ReactTable from 'react-table'
import DatePicker from 'material-ui/DatePicker';


// import InvoiceForm from '../components/InvoiceForm'
class Validation extends Component{
  constructor(props){
    super(props);
    this.state={
      users: []
    }

    this.approve = this.approve.bind(this)
    this.reject = this.reject.bind(this)
  }


  approve(data){
    event.preventDefault();
    let formPayload =
    {
      id: data
    }
    fetch(`/api/v1/validates/${data}`,
    {
      method: 'PATCH',
      credentials: 'same-origin',
      body: JSON.stringify(formPayload)
    })
    .then(response => response.json())
    .then(body => {
      this.setState({users: body}, ()=> {Materialize.toast("Validated", 3000)})
    })
  }
  reject(data){
    event.preventDefault();
    let formPayload =
    {
      id: data
    }
    fetch(`/api/v1/validates/${data}`,
    {
      method: 'DELETE',
      credentials: 'same-origin',
      body: JSON.stringify(formPayload)
    })
    .then(response => response.json())
    .then(body => {
      this.setState({users: body}, ()=> {Materialize.toast("Rejected", 3000)})
    })
  }

  componentDidMount() {
    // let invoiceId = document.getElementById('show').getAttribute('data-id');
    fetch(`/api/v1/validates`, {credentials: "same-origin"})
    .then(response => response.json())
    .then(body => {
      this.setState({users: body})
    });
  }


  render(){

    const columns = [{
      Header: 'Name',
      accessor: 'first_name' // String-based value accessors!
    }, {
      Header: 'Job Type',
      accessor: 'job_type' // String-based value accessors!
    }, {
      Header: 'Email',
      accessor: 'email' // String-based value accessors!
    }, {
      id: 'poof',
      Header: props => <span> Proof </span>,
      Cell: props => <a href="proof.url">Document/Image Proof</a>

    }, {
      id: 'createdAt',
      Header: props => <span>Creation Date</span>,
      accessor: (row)=>row.created_at.slice(0,10)
    }, {
      Header: props => <span>Approve</span>,
      Cell: props => <button onClick={() => this.approve(props.original.id)} className="btn waves-effect">Approve</button>
    }, {
      Header: props => <span>Reject</span>,
      Cell: props => <button onClick={() => this.reject(props.original.id)} className="btn waves-effect">Reject</button>
    }]

     let table =
     <ReactTable
        data={this.state.users}
        columns={columns}
        filterable
        defaultPageSize= {10}
      />
    return(
      <div>
        <h3>Validate Users</h3>
        <br/>
        <br/>
        <div className="table-div">
          {table}
        </div>
      </div>
    )
  }
}


export default Validation
