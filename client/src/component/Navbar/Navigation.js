import React, { useState } from "react";
import { NavLink } from "react-router-dom";
import logo from './logo.png';

import "./Navbar.css";

export default function Navbar() {
  const [open, setOpen] = useState(false);
  return (
    <nav>
      <NavLink to="/" className="header">
        <img src={logo} alt="hanvote logo"/>
      </NavLink>
      <ul
        className="navbar-links"
        style={{ width: "35%", transform: open ? "translateX(0px)" : "" }}
      >
        <li>
          <NavLink to="/Registration" activeClassName="nav-active">
            {/* <i className="far fa-registered" />  */}
            <i class="fa-solid fa-registered"></i>  Registration
          </NavLink>
        </li>
        <li>
          <NavLink to="/Voting" activeClassName="nav-active">
            <i className="fas fa-vote-yea" /> Voting
          </NavLink>
        </li>
        <li>
          <NavLink to="/Results" activeClassName="nav-active">
            <i className="fas fa-poll-h" /> Results
          </NavLink>
        </li>
      </ul>
      <i onClick={() => setOpen(!open)} className="fas fa-bars burger-menu"></i>
    </nav>
  );
}
